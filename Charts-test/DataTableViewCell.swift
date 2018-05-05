//
//  DataTableViewCell.swift
//  Charts-test
//
//  Created by Sarvad shetty on 5/5/18.
//  Copyright © 2018 Sarvad shetty. All rights reserved.
//

import UIKit
import UICountingLabel

class DataTableViewCell: UITableViewCell {

    //MARK:IBOutlets
    @IBOutlet weak var date: UICountingLabel!
    @IBOutlet weak var value: UICountingLabel!
//    self.currentValue.method = .linear
//    self.currentValue.format = "%.2f%"
//    self.currentValue.countFromZero(to: CGFloat(floatData))
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
