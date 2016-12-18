//
//  ViewController.swift
//  IOSAPPLI
//
//  Created by marcel NTOUTOUME-DOUMI on 17/12/2016.
//  Copyright © 2016 Mireille TOULOUBET. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var emailChamp: UITextField!
    @IBOutlet var mdpChamp: UITextField!
    
    
    @IBAction func connexBoutton(_ sender: AnyObject) {
        let email = emailChamp.text
        let mdp = mdpChamp.text
        
        //Si les champs sont vides
        if (email!.isEmpty || mdp!.isEmpty ) {
        let alertController = UIAlertController(title: "Alerte", message:
                "Tous les champs doivent être renseignés", preferredStyle: UIAlertControllerStyle.alert)
            
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
    }
        if (email != "" || mdp != "")
        {
        performSegue(withIdentifier: "segue.selec", sender: self)
        }
}
    
    
    @IBAction func enregBoutton(_ sender: AnyObject) {
        //enregChamp()
        performSegue(withIdentifier: "segue.enreg", sender: self)
    }
    
    //func enregChamp () {
        //emailChamp.text = ""
        //mdpChamp.text = ""
    
    //func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //emailChamp.resignFirstResponder()
        //mdpChamp.resignFirstResponder()
        //return true
    //}
        
        
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
        
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

