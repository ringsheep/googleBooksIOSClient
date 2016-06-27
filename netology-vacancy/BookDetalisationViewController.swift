//
//  BookDetalisationViewController.swift
//  netology-vacancy
//
//  Created by George Zinyakov on 6/27/16.
//  Copyright © 2016 George Zinyakov. All rights reserved.
//

import UIKit
import Foundation

class BookDetalisationViewController: UIViewController, BookDetalisationProtocol
{
    @IBOutlet weak var bookInfoView: UIView!
    @IBOutlet weak var bookDescriptionLabel: UILabel!
    @IBOutlet weak var bookPDFButton: UIButton!
    @IBOutlet weak var bookURLButton: UIButton!
    @IBOutlet weak var bookEPUBButton: UIButton!
    @IBOutlet weak var bookCoverImageView: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookAuthorsLabel: UILabel!
    
    @IBAction func shareButtonPressed(sender: AnyObject) {
        let message:String = "Found on Google Books: " + bookToDisplay.title
        
        let activityViewController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        self.navigationController?.presentViewController(activityViewController, animated: true) {
            
        }
    }
    
    @IBAction func bookURLButtonPressed(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: bookToDisplay.canonicalVolumeLink)!)

    }
    
    @IBAction func bookPDFButtonPressed(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: bookToDisplay.pdfDownloadLink)!)
    }
    
    @IBAction func bookEPUBButtonPressed(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: bookToDisplay.epubDownloadLink)!)
    }
    
    var bookToDisplay : Book!
    
    func bookSelected(newBook: Book) {
        bookToDisplay = newBook
        if ( bookInfoView != nil )
        {
            showView()
            setUpView()
        }
    }
}

// MARK: - View Controller life cycle
extension BookDetalisationViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()
        if ( bookToDisplay != nil )
        {
            showView()
            setUpView()
        }
        else
        {
            hideView()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Настройка вида
extension BookDetalisationViewController
{
    private func setUpView()
    {
        bookCoverImageView.sd_setImageWithURL(NSURL(string: bookToDisplay.thumbnail))
        bookTitleLabel.text = bookToDisplay.title
        bookAuthorsLabel.text = prepareSetForLabel(bookToDisplay.authors)
        bookDescriptionLabel.text = bookToDisplay.descriptionText
        setUpButtons()
    }
    
    private func setUpButtons()
    {
        //  выключаем те кнопки, для которых нет нужного урл
        bookURLButton.enabled = !(bookToDisplay.canonicalVolumeLink.isEmpty)
        bookPDFButton.enabled = !(bookToDisplay.pdfDownloadLink.isEmpty)
        bookEPUBButton.enabled = !(bookToDisplay.epubDownloadLink.isEmpty)

    }
    
    private func hideView()
    {
        bookInfoView.hidden = true
        bookDescriptionLabel.hidden = true
        bookPDFButton.hidden = true
        bookURLButton.hidden = true
        bookEPUBButton.hidden = true
    }
    
    private func showView()
    {
        bookInfoView.hidden = false
        bookDescriptionLabel.hidden = false
        bookPDFButton.hidden = false
        bookURLButton.hidden = false
        bookEPUBButton.hidden = false
    }
    
    private func prepareSetForLabel( set : NSSet ) -> String
    {
        var authorsArray = set.allObjects as! [Author]
        authorsArray.sort({ $0.order < $1.order })
        var finalizedString = ""
        for (index, author) in authorsArray.enumerate()
        {
            if ( index != 0 )
            {
                finalizedString += ", "
            }
            finalizedString += author.name
        }
        return finalizedString
    }
}