//
//  Paiement View Controller.swift
//  IOSAPPLI
//
//  Created by estiam on 25/03/2017.
//  Copyright © 2017 Mireille TOULOUBET. All rights reserved.
//

import UIKit
import SQLite
import  Alamofire

class PaiementViewController: UIViewController , PayPalPaymentDelegate{
    
    @IBOutlet weak var prixLivraisonLabel: UILabel!
    @IBOutlet weak var delaLivraisonLabel: UILabel!
    @IBOutlet weak var methodeLivraisonLabel: UILabel!
    @IBOutlet weak var nbPhotosLabel: UILabel!
    
    @IBOutlet weak var TTCLabel: UILabel!
    
    var prixTot: Double = 0
    
    var environment:String = PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    
    var payPalConfig = PayPalConfiguration()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        print(path)
        do{
            let db = try Connection("\(path)/db.sqlite3")
            let panier = Table("panier")
            let id = Expression<Int64>("id")
            let idUser = Expression<Int64?>("id_user")
            let idLivraison = Expression<Int64?>("id_livraison")
            let nbPhotos = Expression<Int64?>("nb_photos")
            let prixTTC = Expression<Double?>("prixTTC")
            let prixTotal = Expression<Double?>("prixTotal")
            
            
            do{
                do {
                    let preferences = UserDefaults.standard
                    var idU = Int64.init(preferences.string(forKey: "userId")! as String)!
                    var p = Array(try db.prepare(panier.filter(idUser == idU)))[0]
                    if var a = p.get(idLivraison){
                        var idLivraison = a
                        
                        var url = NSURL(string: "http://193.70.40.193:3000/api/shipping/" + String.init(a))
                        var request = URLRequest(url: url as! URL)
                        request.httpMethod = "GET"
                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                        var token = preferences.string(forKey: "token")!
                        request.setValue(token as String, forHTTPHeaderField: "x-access-token")
                        
                        
                        var response = Alamofire.request(request).responseJSON()
                        if let json = response.result.value {
                            let JSON = json as! NSDictionary
                            if (JSON["error"] != nil){
                                let alert = UIAlertController(title: "Alerte", message:
                                    JSON["error"]! as! String, preferredStyle: UIAlertControllerStyle.alert)
                                //Ajout d'une action boutton
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                                //Voir alerte
                                self.present(alert,animated: true, completion: nil)
                                
                            }else{
                                prixLivraisonLabel.text = String.init(JSON["price"] as! Float)
                                methodeLivraisonLabel.text = JSON["name"] as! String
                                delaLivraisonLabel.text = String.init(JSON["shippingDuration"] as! Int)
                                
                                
                            }
                            
                            
                        }
                    }
                    if var a = p.get(nbPhotos){
                        nbPhotosLabel.text = String.init(a)
                        
                        
                    }
                    
                    if var a = p.get(prixTTC){
                        TTCLabel.text = String.init(a)
                    }else{
                        TTCLabel.text = "0"
                    }
                    
                    if var a = p.get(prixTotal){
                        prixTot = a
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
        
        // Set up payPalConfig
        payPalConfig.acceptCreditCards = false
        payPalConfig.merchantName = "PHOTO EXPRESSO"
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        payPalConfig.payPalShippingAddressOption = .both;

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PayPalMobile.preconnect(withEnvironment: environment)
    }
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        print("PayPal Payment Cancelled")
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        print("PayPal Payment Success !")
        paymentViewController.dismiss(animated: true, completion: { () -> Void in
            // send completed confirmaion to your server
            print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
            
        })
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let selectionViewController = storyboard.instantiateViewController(withIdentifier: "segue.Selec")
        self.present(selectionViewController, animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func paypal(_ sender: Any) {
        let payment = PayPalPayment(amount: NSDecimalNumber.init(value: prixTot) , currencyCode: "EUR", shortDescription: "Photos", intent: .sale)
         
         if (payment.processable) {
            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self as! PayPalPaymentDelegate)
            present(paymentViewController!, animated: true, completion: nil)
            
         }
         else {
         // This particular payment will always be processable. If, for
         // example, the amount was negative or the shortDescription was
         // empty, this payment wouldn't be processable, and you'd want
         // to handle that here.
         alert(texte: "Payment not processable: \(payment)")
         }
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
