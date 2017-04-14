//
//  FacturationViewController.swift
//  IOSAPPLI
//
//  Created by estiam on 25/03/2017.
//  Copyright © 2017 Mireille TOULOUBET. All rights reserved.
//

import UIKit
import Alamofire
import SQLite

class FacturationViewController: UIViewController {

    @IBOutlet weak var nom: UITextField!
    @IBOutlet weak var prenom: UITextField!
    @IBOutlet weak var rue: UITextField!
    @IBOutlet weak var cp: UITextField!
    @IBOutlet weak var ville: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickValider(_ sender: Any) {
        if((nom.text! == "") || (prenom.text! == "") || (rue.text! == "") || (cp.text! == "") || (ville.text! == "")){
            alert(texte: "Veuillez renseigner tout les champs")
        }
        var url = NSURL(string: "http://193.70.40.193:3000/api/address")
        var requestA = URLRequest(url: url as! URL)
        requestA.httpMethod = "PUT"
        requestA.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        requestA.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let preferences = UserDefaults.standard
        var token = preferences.string(forKey: "token")!

        requestA.setValue(token as String, forHTTPHeaderField: "x-access-token")
        
        let idU = Int.init(preferences.string(forKey: "userId")! as String)!
        
        let postData = NSMutableData(data: ("ZC="+cp.text!).data(using: String.Encoding.utf8)!)
        postData.append(("&street="+rue.text!).data(using: String.Encoding.utf8)!)
        postData.append(("&city="+ville.text!).data(using: String.Encoding.utf8)!)
        postData.append(("&nom="+nom.text!).data(using: String.Encoding.utf8)!)
        postData.append(("&prenom="+prenom.text!).data(using: String.Encoding.utf8)!)
        postData.append(("&type="+"Billing").data(using: String.Encoding.utf8)!)
        postData.append(("&userID="+String.init(idU)).data(using: String.Encoding.utf8)!)
        
        let jsonObject: [String: Any] = [
            "street": rue.text!,
            "ZC"	: cp.text!,
            "city"  : ville.text!,
            "nom"   : nom.text!,
            "prenom": prenom.text!,
            "type"  : "Billing",
            "userID": idU
        ]
        
        debugPrint(JSONSerialization.isValidJSONObject(jsonObject)) // true
        
        //let header = 	["Content-Type": "application/x-www-form-urlencoded", "Accept": "application/json", "Authorization":"a"]
        
        requestA.httpBody = postData as Data
        
        print(NSString(data: (requestA.httpBody)!, encoding: String.Encoding.utf8.rawValue))
        var a = Alamofire.request(requestA).responseJSON()
        if let response = a.result.value{
            print(response)
            
            url = NSURL(string: "http://193.70.40.193:3000/api/address/" + String.init(idU))
            var request = URLRequest(url: url as! URL)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            token = preferences.string(forKey: "token")!
            request.setValue(token as String, forHTTPHeaderField: "x-access-token")
            
            
            var res = Alamofire.request(request).responseJSON()
            if let json = res.result.value  {
                print(json)
                if (json as? NSDictionary == nil ){
                    var length = (json as! NSArray).count - 1
                    for var i in 0 ... length{
                        var JSON = (json as! NSArray)[i] as! NSDictionary
                        print(JSON)
                        if(JSON["type"] as! String == "Billing"){
                            var adresseId = JSON["id"] as! Int64
                            let path = NSSearchPathForDirectoriesInDomains(
                                .documentDirectory, .userDomainMask, true
                                ).first!
                            print(path)
                            do{
                                let db = try Connection("\(path)/db.sqlite3")
                                let panier = Table("panier")
                                let idUser = Expression<Int64?>("id_user")
                                let idAdresse = Expression<Int64?>("id_adresse")
                                
                                do{
                                    do {
                                        do {
                                            if try db.run(panier.filter(idUser == Int64.init(idU)).update(idAdresse <- adresseId)) > 0 {
                                                print("updated alice")
                                            } else {
                                                print("alice not found")
                                            }
                                        } catch {
                                            print("update failed: \(error)")
                                        }
                                        
                                    } catch {
                                        print("récupération impossible: \(error)")
                                    }
                                }catch{
                                    print("création de la table panier impossible: \(error)")
                                }
                            }
                            catch{
                                print("connection impossible: \(error)")
                            }
                        }
                        
                    }
                }
                
            }
            
            
        }
        
        performSegue(withIdentifier: "segue.livraison", sender: self)
        
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
