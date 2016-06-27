//
//  BookTableViewCell.swift
//  netology-vacancy
//
//  Created by George Zinyakov on 6/26/16.
//  Copyright © 2016 George Zinyakov. All rights reserved.
//

import UIKit
import SDWebImage

class BookTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bookThumbnailImageView: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookAuthorsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureSelfWithData( thumbnailURL : String , title : String , authors : NSSet )
    {
        bookThumbnailImageView.sd_setImageWithURL(NSURL(string: thumbnailURL))
        bookTitleLabel.text = title
        bookAuthorsLabel.text = prepareSetForLabel(authors)
    }
    
    func prepareSetForLabel( set : NSSet ) -> String
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
    
    func updateFonts()
    {
        bookTitleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        bookAuthorsLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption2)
    }
    
    override func prepareForReuse()
    {
        bookThumbnailImageView.image = nil
        bookTitleLabel.text = ""
        bookAuthorsLabel.text = ""
    }

}
