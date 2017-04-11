//
//  LivraisonViewController.swift
//  IOSAPPLI
//
//  Created by estiam on 26/03/2017.
//  Copyright © 2017 Mireille TOULOUBET. All rights reserved.
//

import UIKit
import Alamofire
import SQLite

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
            let JSONArray = json as! NSArray
            debugPrint(JSONArray)
            if JSONArray != nil{
                for var index in 0 ... (JSONArray.count - 1){
                    var JSON = JSONArray[index] as! NSDictionary
                    debugPrint(JSON)
                    if (JSON["error"] != nil){
                        let alert = UIAlertController(title: "Alerte", message:
                            JSON["error"]! as! String, preferredStyle: UIAlertControllerStyle.alert)
                        //Ajout d'une action boutton
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                        //Voir alerte
                        self.present(alert,animated: true, completion: nil)
                        
                    }else{
                        livraisonsArray.append(Livraison(id: JSON["id"]! as! Int64,name: JSON["name"]! as! String, price: JSON["price"]! as! Float, shippingDuration: JSON["shippingDuration"]! as! Int))
                        
                    }
                }
            
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
        
        cell.delaiLivraison.text = String.init(methode.shippingDuration) + " jours"
        cell.nomLivraison.text = methode.name
        cell.prixLivraison.text = String.init(methode.price) + " €"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SelectionViewController.imageTapped(sender:)))
        cell.addGestureRecognizer(tapGesture)
        
        return cell
        
    }
    
    func imageTapped(sender : UITapGestureRecognizer) {
        var tapLocation = sender.location(in: self.tableView)
        var NSIndexPath = self.tableView.indexPathForRow(at: tapLocation)
        var liv = self.livraisonsArray[(NSIndexPath?[1])!]
        
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        print(path)
        do{
            let db = try Connection("\(path)/db.sqlite3")
            let panier = Table("panier")
            let idUs = Expression<Int64?>("id_user")
            let idLivraison = Expression<Int64?>("id_livraison")
            let prixTotal = Expression<Double?>("prixTotal")
            let prixTTC = Expression<Double?>("prixTTC")
            
            do{
                do {
                    do {
                        if try db.run(panier.filter(idUs == Int64.init(idUser!)).update(idLivraison <- liv.id)) > 0 {
                            print("updated alice")
                        } else {
                            print("alice not found")
                        }
                        var ttc = Array(try db.prepare(panier.filter(idUs == Int64.init(idUser!))))[0].get(prixTTC)
                        if(ttc == nil){
                            ttc = 0
                        }
                        var prixT = Double(liv.price + Float(ttc!))
                        print(prixT)
                        if try db.run(panier.filter(idUs == Int64.init(idUser!)).update(prixTotal <- prixT)) > 0 {
                            print("updated alice")
                        } else {
                            print("alice not found")
                        }
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let selectionViewController = storyboard.instantiateViewController(withIdentifier: "segue.Payment")
                        self.present(selectionViewController, animated: true)

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
