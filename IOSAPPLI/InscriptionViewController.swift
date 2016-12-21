//
//  InscriptionViewController.swift
//  IOSAPPLI
//
//  Created by marcel NTOUTOUME-DOUMI on 17/12/2016.
//  Copyright © 2016 Mireille TOULOUBET. All rights reserved.
//

import UIKit

class InscriptionViewController: UIViewController {

    @IBOutlet weak var nomChamp: UITextField!
    
    @IBOutlet weak var prenomChamp: UITextField!
    
    @IBOutlet weak var datenaiChamp: UITextField!
    
    @IBOutlet weak var emailChamp: UITextField!
    
    @IBOutlet weak var pseudoChamp: UITextField!
    
    @IBOutlet weak var mdpChamp: UITextField!
    
    @IBOutlet weak var repmdpChamp: UITextField!
    
    
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
        let nom = nomChamp.text!
        let prenom = prenomChamp.text!
        let datenai = datenaiChamp.text!
        let email = emailChamp.text!
        let pseudo = pseudoChamp.text!
        let mdp = mdpChamp.text!
        let repmdp = repmdpChamp.text!
        
        
        //Vérifier si les hamps sont vides
        if (nom.isEmpty || prenom.isEmpty || datenai.isEmpty || email.isEmpty || pseudo.isEmpty || mdp.isEmpty || (repmdp.isEmpty))
            
        {
            //Afficher les messages d'alerte
                //displayMyAlertMessage("Tous les champs doivent être renseignés")//
            let alertController = UIAlertController(title: "Alerte", message:
                "Tous les champs doivent être renseignés", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }

        
        //Vérifier la correspondance des mots de passe
        if ( (nom != "" || prenom != "" || datenai != "" || email != "" || pseudo != "" || mdp != "" || repmdp != "") && (mdp != repmdp))
    
        {
            //Afficher un message d'alerte
            
            //Création de l'alerte
            let alert = UIAlertController(title: "Alerte", message:
                "Les mots de passe doivent être identiques", preferredStyle: UIAlertControllerStyle.alert)
            //Ajout d'une action boutton
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
            //Voir alerte
            self.present(alert,animated: true, completion: nil)
        }
        
        
        
        if (nom != "" || prenom != "" || datenai != "" || email != "" || pseudo != "" || mdp != "" || repmdp != "" )
            {
                performSegue(withIdentifier: "segue.selec", sender: self)
            }
    }
    
    
    @IBAction func connecBoutton(_ sender: AnyObject) {
    performSegue(withIdentifier: "segue.reconnec", sender: self)
    }
}
