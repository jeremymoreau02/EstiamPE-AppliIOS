//
//  UserInfoController.swift
//  IOSAPPLI
//
//  Created by estiam on 21/02/2017.
//  Copyright © 2017 Mireille TOULOUBET. All rights reserved.
//

import UIKit
import Alamofire

class UpdateUserViewController: UIViewController {
    
    @IBOutlet weak var rue: UITextField!
    @IBOutlet weak var cp: UITextField!
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var ville: UITextField!
    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var dateDeNaissance: UITextField!
    @IBOutlet weak var pseudo: UITextField!
    @IBOutlet weak var prenom: UITextField!
    @IBOutlet weak var nom: UITextField!
    let user = User()
    let adresse = Adresse()
    var idUser: String = ""
    var token: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let preferences = UserDefaults.standard
        idUser = preferences.string(forKey: "userId")! as String
        user.userId = Int.init(idUser)!
        var url = NSURL(string: "http://193.70.40.193:3000/api/users/" + idUser)
        var request = URLRequest(url: url as! URL)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        token = preferences.string(forKey: "token")!
        request.setValue(token as String, forHTTPHeaderField: "x-access-token")

        
        var response = Alamofire.request(request).responseJSON()
        if let json = response.result.value {
            let JSON = json as! NSDictionary
            print(JSON)
            if (JSON["error"] != nil){
                let alert = UIAlertController(title: "Alerte", message:
                    JSON["error"]! as! String, preferredStyle: UIAlertControllerStyle.alert)
                //Ajout d'une action boutton
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                //Voir alerte
                self.present(alert,animated: true, completion: nil)
                
            }else{
                var date = JSON["dateNaissance"]! as! String
                date = date.components(separatedBy: "T")[0]
                let dateJ = date.components(separatedBy: "-")[2]
                let dateM = date.components(separatedBy: "-")[1]
                let dateA = date.components(separatedBy: "-")[0]
                dateDeNaissance.text = dateJ+"/"+dateM+"/"+dateA
                email.text = JSON["email"]! as! String
                nom.text = JSON["nom"]! as! String
                prenom.text = JSON["prenom"]! as! String
                pseudo.text = JSON["pseudo"]! as! String
                user.email = JSON["email"]! as! String
                user.dateNaissance = date
                user.nom = JSON["nom"]! as! String
                user.prenom = JSON["prenom"]! as! String
            
            }
            
        }
        
        url = NSURL(string: "http://193.70.40.193:3000/api/address/" + idUser)
        request = URLRequest(url: url as! URL)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        token = preferences.string(forKey: "token")!
        request.setValue(token as String, forHTTPHeaderField: "x-access-token")
        
        
        response = Alamofire.request(request).responseJSON()
        if let json = response.result.value  {
            print(json)
            if (json as! NSDictionary == nil ){
            var length = (json as! NSArray).count
            for var i in 0 ... length{
                var JSON = (json as! NSArray)[i] as! NSDictionary
                print(JSON)
                    if(JSON["type"] as! String == "Shipping"){
                        adresse.city = JSON["city"] as! String
                        ville.text = JSON["city"] as! String
                        adresse.street = JSON["street"] as! String
                        rue.text = JSON["street"] as! String
                        adresse.ZC = JSON["ZC"] as! String
                        cp.text = JSON["ZC"] as! String
                        adresse.UserId = JSON["userId"] as! Int
                        adresse.createdAt = JSON["createdAd"] as! String
                        adresse.updatedAt = JSON["updatedAt"] as! String
                        adresse.id = JSON["id"] as! Int
                        adresse.type = JSON["type"] as! String
                    }
                
            }
            }
            
        }

        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
    
 
   @IBAction func onClickValider(_ sender: Any) {
        var bon: Bool = true
    
    if(!(dateDeNaissance.text=="")){
        let tab = dateDeNaissance.text?.components(separatedBy: "/")
        
        if(tab?.count == 3){
            let str = (tab?[2])!+"-"+(tab?[1])!+"-"+(tab?[0])!
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd"
            
            if (dateFormatterGet.date(from: str) != nil) {
                user.dateNaissance = str
            } else {
                alert(texte: "Date de naissance invalide")
                bon = false
            }
        }else{
            alert(texte: "Date de naissance invalide")
            bon = false
        }
        
        if(!(oldPassword.text=="") || !(confirmPassword.text=="") || !(newPassword.text=="")) {
            if(oldPassword.text==""){
                alert(texte: "ancien mot de passe vide")
                bon=false
            }else{
                if(newPassword.text==""){
                    alert(texte: "nouveau mot de passe vide")
                    bon=false
                }else{
                    if(confirmPassword.text==""){
                        alert(texte: "confirmation du mot de passe vide")
                        bon=false
                    }
                }
            }
            if(oldPassword.text==newPassword.text) {
                alert(texte: "mot de passe inchangé")
                bon=false
            }
            if(!(confirmPassword.text==newPassword.text)) {
                alert(texte: "mots de passes differents")
                bon=false;
            }
        }
        
        if(bon) {
            
            if (!(email.text=="")) {
                if (!isValidEmail(testStr: email.text!)) {
                    alert(texte: "Email invalide")
                } else {
                    user.email = email.text!
                }
            }
            
            if (pseudo.text==""){ user.pseudo = pseudo.text!}
            if (nom.text==""){ user.nom = nom.text!}
            if (prenom.text==""){ user.prenom = prenom.text!}
            
            if(!((newPassword.text==""||oldPassword.text==""))){
                user.password = newPassword.text!
            }
            user.oldPassword = oldPassword.text!
            
            
            adresse.UserId = user.userId
            if (!(cp.text=="")){ adresse.ZC = cp.text!}
            if (!(rue.text=="")){ adresse.street = rue.text!}
            if (!(ville.text=="")){ adresse.city = ville.text!}
            adresse.type = "Billing."
            
            var url = NSURL(string: "http://193.70.40.193:3000/api/user/" + idUser)
            var request = URLRequest(url: url as! URL)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue(token as String, forHTTPHeaderField: "x-access-token")
            
            var jsonObject: [String: Any] = [
                "nom": user.nom,
                "prenom": user.prenom,
                "age": user.age,
                "dateNaissance": user.dateNaissance,
                "userId": user.userId,
                "pseudo": user.pseudo,
                "email": user.email,
                "role": user.role,
                "password": user.password,
                "oldPassword": user.oldPassword,
            ]
            
            debugPrint(JSONSerialization.isValidJSONObject(jsonObject)) // true
            
            //let header = 	["Content-Type": "application/x-www-form-urlencoded", "Accept": "application/json", "Authorization":"a"]
            
            request.httpBody = try! JSONSerialization.data(withJSONObject: jsonObject)
            
            debugPrint(Alamofire.request(request).responseJSON { response in
                
                print("fguhjkl")
                debugPrint(response)
            })
            
             url = NSURL(string: "http://193.70.40.193:3000/api/address/" + String.init(adresse.id))
             request = URLRequest(url: url as! URL)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue(token as String, forHTTPHeaderField: "x-access-token")
            
            jsonObject = [
                "id": adresse.id,
                "UserId" : adresse.UserId,
                "city" : adresse.city,
                "createdAt" : adresse.createdAt,
                "updatedAt" : adresse.updatedAt,
                "street" : adresse.street,
                "type" : adresse.type,
                ]
            
            debugPrint(JSONSerialization.isValidJSONObject(jsonObject)) // true
            
            //let header = 	["Content-Type": "application/x-www-form-urlencoded", "Accept": "application/json", "Authorization":"a"]
            
            request.httpBody = try! JSONSerialization.data(withJSONObject: jsonObject)
            
            debugPrint(Alamofire.request(request).responseJSON { response in
                
                print("fguhjkl")
                debugPrint(response)
            })

            
        }

    }
    
    }
    
    func isValidEmail(testStr:String) -> Bool {
        print("validate emilId: \(testStr)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
}
