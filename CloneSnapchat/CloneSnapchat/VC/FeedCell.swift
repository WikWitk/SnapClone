//
//  FeedCellTableViewCell.swift
//  CloneSnapchat
//
//  Created by Wiktor Witkowski on 18/02/2024.
//

import UIKit

class FeedCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var feedImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
