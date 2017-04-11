//
//  panierCellTableViewCell.swift
//  IOSAPPLI
//
//  Created by estiam on 04/04/2017.
//  Copyright © 2017 Mireille TOULOUBET. All rights reserved.
//

import UIKit

class panierCellTableViewCell: UITableViewCell {

    @IBOutlet weak var qte: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var suppBtn: UIButton!
    @IBOutlet weak var supprimer: UIImageView!
    @IBOutlet weak var prix: UILabel!
    @IBOutlet weak var moins: UIButton!
    @IBOutlet weak var plus: UIButton!
    @IBOutlet weak var desc: UITextView!
}
