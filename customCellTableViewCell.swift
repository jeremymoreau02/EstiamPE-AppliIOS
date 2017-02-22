//
//  customCellTableViewCell.swift
//  IOSAPPLI
//
//  Created by estiam on 21/02/2017.
//  Copyright © 2017 Mireille TOULOUBET. All rights reserved.
//

import UIKit

class customCellTableViewCell: UITableViewCell {

    
    @IBOutlet weak var DPTitreView: UIView!
    @IBOutlet weak var DPChantsView: UIView!
    
    @IBOutlet weak var DPHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var showDetails = false {
        didSet{
            DPHeightConstraint.priority = showDetails ? 250 : 999
        }
    }

}
