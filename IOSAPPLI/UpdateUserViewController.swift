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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let preferences = UserDefaults.standard
        let id = preferences.string(forKey: "userId")! as String
        let url = NSURL(string: "http://193.70.40.193:3000/api/users/" + id)
        var request = URLRequest(url: url as! URL)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        
        let response = Alamofire.request(request).responseJSON()
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
                print(JSON["userId"] as! Int)
                let preferences = UserDefaults.standard
                
                preferences.set(JSON["userId"] as! Int, forKey: "userId")
                preferences.set(JSON["token"] as! String, forKey: "token")
                
                let date = NSDate()
                let calendar = NSCalendar.current
                let heures = calendar.component(.hour, from: date as Date) as NSNumber
                let minutes = calendar.component(.minute, from: date as Date) as NSNumber
                let secondes = calendar.component(.second, from: date as Date) as NSNumber
                let jour = calendar.component(.day, from: date as Date) as NSNumber
                let mois = calendar.component(.month, from: date as Date) as NSNumber
                let annee = calendar.component(.year, from: date as Date) as NSNumber
                
                let stringDate = annee.stringValue + "/"+mois.stringValue+"/"+jour.stringValue+" "+heures.stringValue+":"+minutes.stringValue+":"+secondes.stringValue
                preferences.set(stringDate as! String, forKey:"creationDate")
                
                
                //  Save to disk
                preferences.synchronize()
            }
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func onClickValider(_ sender: Any) {
        
    }
   /* @IBAction func onClickValider(_ sender: Any) {
        var bon: Bool = true
        
        /*let tab = dateDeNaissance.text?.components(separatedBy: "/")
        let str = (tab?[2])!+"-"+(tab?[1])!+"-"+(tab?[0])!
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatterGet.date(from: str)! as? Date {
            debugPrint(date)
        } else {
            
        }*/
    }*/
    
}
