//
//  InscriptionViewController.swift
//  IOSAPPLI
//
//  Created by marcel NTOUTOUME-DOUMI on 17/12/2016.
//  Copyright © 2016 Mireille TOULOUBET. All rights reserved.
//

import UIKit
import Alamofire

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
            alert(texte: "Tous les champs doivent être renseignés")
        }

        
        //Vérifier la correspondance des mots de passe
        if ( (nom != "" || prenom != "" || datenai != "" || email != "" || pseudo != "" || mdp != "" || repmdp != "") && (mdp != repmdp))
    
        {
                alert(texte: "Les mots de passe doivent être identiques")
        }
        
        
        
        if (nom != "" || prenom != "" || datenai != "" || email != "" || pseudo != "" || mdp != "" || repmdp != "" )
            {
                let decoupage = datenai.components(separatedBy: "/")
                if(decoupage.count != 3){
                    alert(texte: "La date n'est pas de ce format: DD/MM/YYYY")
                }else{
                    let day = decoupage[0]
                    let month = decoupage[1]
                    let year = decoupage[2]
                
                    let date = Date()
                    let calendar = Calendar.current
                
                    if((((month == "02")||(month == "04")||(month == "06")||(month == "09")||(month == "11"))&&(day == "31"))||((day as NSString).integerValue>31)||((day as NSString).integerValue<1) || !(day.characters.count==2)){
                        alert(texte: "Le jour de la date est invalide")
                    }
                
                    if(((month as NSString).integerValue>12)||((month as NSString).integerValue<1) || !(month.characters.count==2)){
                        alert(texte: "Le mois de la date est invalide")
                    }
                    
                    debugPrint((year as NSString).integerValue)
                    debugPrint(calendar.component(.year, from: date))
                
                    if(((year as NSString).integerValue>calendar.component(.year, from: date))||((year as NSString).integerValue<1900) || !(year.characters.count==4)){
                        alert(texte: "L'année de la date est invalide")
                    }
                
                    if(isValidEmail(testStr: email) == false){
                        alert(texte: "L'adresse email est invalide")
                    }
                    let url = NSURL(string: "http://193.70.40.193:3000/api/inscription")
                    var request = URLRequest(url: url as! URL)
                    request.httpMethod = "PUT"
                    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                    request.setValue("application/json", forHTTPHeaderField: "Accept")
                
                    let jsonObject: [String: String] = [
                        "pseudo": "mimir02",
                        "password"	: "virgule02"
                    ]
                
                    debugPrint(JSONSerialization.isValidJSONObject(jsonObject)) // true
                
                    //let header = 	["Content-Type": "application/x-www-form-urlencoded", "Accept": "application/json", "Authorization":"a"]
                
                    request.httpBody = try! JSONSerialization.data(withJSONObject: jsonObject)
                
                    debugPrint(Alamofire.request(request).responseJSON { response in
                    
                        print("fguhjkl")
                        debugPrint(response)
                    })

                    //performSegue(withIdentifier: "segue.selec", sender: self)
                }
        }
    }
    
    
    @IBAction func connecBoutton(_ sender: AnyObject) {
        performSegue(withIdentifier: "segue.reconnec", sender: self)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func alert(texte: String){
        //Afficher un message d'alerte
        
        //Création de l'alerte
        let alert = UIAlertController(title: "Alerte", message:
            texte, preferredStyle: UIAlertControllerStyle.alert)
        //Ajout d'une action boutton
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        //Voir alerte
        self.present(alert,animated: true, completion: nil)

    }
}
