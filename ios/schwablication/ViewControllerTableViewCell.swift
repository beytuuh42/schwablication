//
//  ViewControllerTableViewCell.swift
//  schwablication
//
//  Created by bi on 18.06.18.
//  Copyright © 2018 Hochschule der Medien. All rights reserved.
//

import UIKit

class ViewControllerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
