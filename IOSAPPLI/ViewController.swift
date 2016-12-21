//
//  ViewController.swift
//  IOSAPPLI
//
//  Created by marcel NTOUTOUME-DOUMI on 17/12/2016.
//  Copyright © 2016 Mireille TOULOUBET. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet var pseudoChamp: UITextField!
    @IBOutlet var mdpChamp: UITextField!
    
    
    @IBAction func connexBoutton(_ sender: AnyObject) {
        let pseudo = pseudoChamp.text
        let mdp = mdpChamp.text
        
        //Si les champs sont vides
        if (pseudo!.isEmpty || mdp!.isEmpty ) {
        //Création de l'alerte
        let alert = UIAlertController(title: "Alerte", message:
        "Tous les champs doivent être renseignés", preferredStyle: UIAlertControllerStyle.alert)
        //Ajout d'une action boutton
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        //Voir alerte
        self.present(alert,animated: true, completion: nil)
        
        //displayMyAlertMessage("Tous les champs sont requis");
        //return;
        }
        
        
        if (pseudo != "" || mdp != "")
        {
        performSegue(withIdentifier: "segue.selec", sender: self)
        }
        
        
        
        let config = URLSessionConfiguration.default // Session Configuration        
        let session = URLSession(configuration: config) // Load configuration into Session        
        let url = URL(string: "193.70.40.193:3000/api/connection")!
        let task = session.dataTask(with: url, completionHandler: {(data, response, error) in                            if error != nil {
        print(error!.localizedDescription)}
        else {
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]                        {
                    //Implement your logic                           
                    print(json)
                }
            }
            catch {print("error in JSONSerialization")
                
            }
        }
    })
task.resume()
    
    
    
}
    
    
    @IBAction func enregiBoutton(_ sender: AnyObject) {
        performSegue(withIdentifier: "segue.enreg", sender: self)
    }
    
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

