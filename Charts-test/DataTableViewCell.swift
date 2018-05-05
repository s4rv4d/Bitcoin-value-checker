//
//  DataTableViewCell.swift
//  Charts-test
//
//  Created by Sarvad shetty on 5/5/18.
//  Copyright © 2018 Sarvad shetty. All rights reserved.
//

import UIKit

class DataTableViewCell: UITableViewCell {

    //MARK:IBOutlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var value: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
