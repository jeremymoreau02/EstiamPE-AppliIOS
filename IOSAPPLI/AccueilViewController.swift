//
//  AccueilViewController.swift
//  IOSAPPLI
//
//  Created by marcel NTOUTOUME-DOUMI on 19/12/2016.
//  Copyright © 2016 Mireille TOULOUBET. All rights reserved.
//

import UIKit

class AccueilViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func suivantBoutton(_ sender: AnyObject)
    {
        performSegue(withIdentifier: "segue.connec", sender: self)
    }

}
