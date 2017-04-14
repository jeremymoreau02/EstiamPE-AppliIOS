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
        let preferences = UserDefaults.standard
        
        if (preferences.string(forKey: "DejaUtilise") != nil){
            
            if (preferences.string(forKey: "DejaUtilise")! as String == "oui"){
                performSegue(withIdentifier: "segue.connec", sender: self)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func suivantBoutton(_ sender: AnyObject)
    {
        let preferences = UserDefaults.standard
        
        preferences.set("oui", forKey: "DejaUtilise")
        preferences.synchronize()
        
    
        performSegue(withIdentifier: "segue.connec", sender: self)
    }

}
