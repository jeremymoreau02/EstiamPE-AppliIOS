//
//  LivraisonViewController.swift
//  IOSAPPLI
//
//  Created by estiam on 26/03/2017.
//  Copyright © 2017 Mireille TOULOUBET. All rights reserved.
//

import UIKit
import Alamofire

class LivraisonViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var idUser: String?
    var livraisonsArray: [Livraison] = [Livraison]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        
        let preferences = UserDefaults.standard
        idUser = preferences.string(forKey: "userId")! as String
        var url = NSURL(string: "http://193.70.40.193:3000/api/shipping")
        var request = URLRequest(url: url as! URL)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        var token = preferences.string(forKey: "token")!
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
                livraisonsArray.append(Livraison(name: JSON["name"]! as! String, price: JSON["name"]! as! Float, shippingDuration: JSON["name"]! as! Int))
                
            }
            
        }
        
        super.viewDidLoad()
        
        tableView.reloadData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return livraisonsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellContenu", for: indexPath) as! LivraisonTableViewCell
        let methode = livraisonsArray[indexPath.row] as Livraison
        
        cell.delaiLivraison.text = String.init(methode.shippingDuration)
        cell.nomLivraison.text = methode.name
        cell.prixLivraison.text = String.init(methode.price)
        
        return cell
        
    }
}
