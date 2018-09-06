//
//  ContactsTableViewCell.swift
//  ContacsUIApplication
//
//  Created by Jagan Mohan on 05/09/18.
//  Copyright © 2018 Jagan Mohan. All rights reserved.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
