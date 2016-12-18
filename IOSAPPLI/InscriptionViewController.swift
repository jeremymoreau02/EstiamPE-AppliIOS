//
//  InscriptionViewController.swift
//  IOSAPPLI
//
//  Created by marcel NTOUTOUME-DOUMI on 17/12/2016.
//  Copyright © 2016 Mireille TOULOUBET. All rights reserved.
//

import UIKit

class InscriptionViewController: UIViewController {

    @IBOutlet var nomChamp: UITextField!
    
    @IBOutlet var prenomChamp: UITextField!
    
    @IBOutlet var datenaiChamp: UITextField!
    
    @IBOutlet var emailChamp: UITextField!
    
    @IBOutlet var pseudoChamp: UITextField!
    
    @IBOutlet var mdpChamp: UITextField!
    
    @IBOutlet var remdpChamp: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
}

    //func alerteMessge (title:String, message:String)
    //{let alert = UIAlertController(title:title, message: message, preferredStyle: <#T##UIAlertControllerStyle#>)
        //alert.addAction(UIAlertAction(title: "OK", style:UIAlertControllerStyle.alert)
    
    @IBAction func enregBoutton(_ sender: AnyObject) {
        //var nom:NSString = nomChamp.text
        //var utilisateur:Struct_Utilisateur()
        //utilisateur.nom = nomChamp.text
        let nom = nomChamp.text
        let prenom = prenomChamp.text
        let datenai = datenaiChamp.text
        let email = emailChamp.text
        let pseudo = pseudoChamp.text
        let mdp = mdpChamp.text
        let repmdp = remdpChamp.text
        
        
        //Vérifier si les hamps sont vides
        if (nom!.isEmpty || prenom!.isEmpty || datenai!.isEmpty || email!.isEmpty || pseudo!.isEmpty || mdp!.isEmpty || (repmdp != nil))
            
        {
            //Afficher les messages d'alerte
                //displayMyAlertMessage("Tous les champs doivent être renseignés")//
            let alertController = UIAlertController(title: "Alerte", message:
                "Tous les champs doivent être renseignés", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }

        
        //Vérifier la correspondance des mots de passe
        if (mdp != repmdp)
    
        {
            //Afficher un message d'alerte
            let alertController = UIAlertController(title: "Alerte", message: "Les mots de passe deoivente être identiques", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
            {
                (result : UIAlertAction) -> Void in
                print("Appuyer sur OK")
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            //return
        }
    
    }
    
    @IBAction func connecBoutton(_ sender: AnyObject) {
    
    }
}
