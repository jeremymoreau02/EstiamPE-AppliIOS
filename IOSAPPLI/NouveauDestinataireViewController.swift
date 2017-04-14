//
//  NouveauDestinataireViewController.swift
//  IOSAPPLI
//
//  Created by estiam on 18/03/2017.
//  Copyright © 2017 Mireille TOULOUBET. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import SQLite


class NouveauDestinataireViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CNContactPickerDelegate  {

    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var nom: UITextField!
    @IBOutlet weak var prenom: UITextField!
    @IBOutlet weak var Mobile: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var rue: UITextField!
    @IBOutlet weak var cp: UITextField!
    @IBOutlet weak var ville: UITextField!
    @IBOutlet weak var contact: UIImageView!
    
    var imageMsq: UIImage?
    
    var imageUrl: String?
    var imageId: Int64?
    var imagePrix: Double?
    
    var image : Photo = Photo(url: URL(string: "https://www.apple.com")!, uiimage: UIImage())
    var urlFinale: String?
    
    var idU: Int64 = 0
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
     var pickerData: [String] = [String]()
    
    func contactPickerDidCancel(picker: CNContactPickerViewController) {
        print("Cancelled picking a contact")
    }
    
    func contactPicker(picker: CNContactPickerViewController,
                       didSelectContact contact: CNContact) {
        
        print("Selected a contact")
        
        if contact.isKeyAvailable(CNContactPhoneNumbersKey){
            //this is an extension I've written on CNContact
            debugPrint(contact)
        } else {
            /*
             TOOD: partially fetched, use what you've learnt in this chapter to
             fetch the rest of this contact
             */
            print("No phone numbers are available")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.picker.delegate = self
        self.picker.dataSource = self
        
        pickerData = ["Monsieur", "Madame", "Mademoiselle", "Monsieur et Madame" ]

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    @IBAction func onClickValider(_ sender: Any) {
        if((nom.text=="") || (prenom.text=="") || (Mobile.text=="")){
            alert(texte: "Tout les champs doivent être renseignés")
        }else{
            if((Email.text=="") || (cp.text=="") || (rue.text=="") || (ville.text=="")){
                alert(texte: "Tout les champs doivent être renseignés")
            }else{
                if(!isValidMobile(testStr: Mobile.text!)){
                    alert(texte: "Mobile invalide")
                }
                if(!isValidEmail(testStr: Email.text!)){
                    alert(texte: "Email invalide")
                }
                
                let path = NSSearchPathForDirectoriesInDomains(
                    .documentDirectory, .userDomainMask, true
                    ).first!
                print(path)
                do{
                    let db = try Connection("\(path)/db.sqlite3")
                    let destinataires = Table("destinataires")
                    let id = Expression<Int64>("id")
                    let idMessage = Expression<Int64?>("idMessage")
                    let idPhoto = Expression<Int64?>("idPhoto")
                    let idUser = Expression<Int64?>("idUser")
                    let civiliteDest = Expression<String?>("civilite")
                    let nomDest = Expression<String?>("nom")
                    let prenomDest = Expression<String?>("prenom")
                    let mobileDest = Expression<String?>("mobile")
                    let emailDest = Expression<String?>("email")
                    let rueDest = Expression<String?>("rue")
                     let cpDest = Expression<String?>("cp")
                     let villeDest = Expression<String?>("ville")
                    
                    do{
                        try db.run(destinataires.create(ifNotExists: true) { t in     // CREATE TABLE "users" (
                            t.column(id, primaryKey: true) //     "id" INTEGER PRIMARY KEY NOT NULL,
                            t.column(idMessage, defaultValue: 0)
                            t.column(idUser, defaultValue: 0)
                            t.column(idPhoto, defaultValue: 0)
                            t.column(civiliteDest, defaultValue: "")
                            t.column(nomDest, defaultValue: "")
                            t.column(prenomDest, defaultValue: "")
                            t.column(mobileDest, defaultValue: "")
                            t.column(emailDest, defaultValue: "")
                            t.column(rueDest, defaultValue: "")
                            t.column(cpDest, defaultValue: "")
                            t.column(villeDest, defaultValue: "")
                        })

                        let preferences = UserDefaults.standard
                        idU = Int64.init(preferences.string(forKey: "userId")! as String)!
                        do{
                            try db.run(destinataires.insert(idUser <- idU, civiliteDest <- pickerData[picker.selectedRow(inComponent: 0)], nomDest <- nom.text, prenomDest <- prenom.text, mobileDest <- Mobile.text, emailDest <- Email.text, rueDest <- rue.text, cpDest <- cp.text, villeDest <- ville.text))
                            
                            performSegue(withIdentifier: "segue.refreshDestinataires", sender: self)
                        }catch{
                            alert(texte: "insertion impossible: \(error)")
                            print("insertion impossible: \(error)")
                        }
                            
                    }catch{
                        alert(texte: "création de la table panier impossible: \(error)")
                        print( "création de la table panier impossible: \(error)")
                    }
                }
                catch{
                    alert(texte: "connection impossible: \(error)")
                    print( "connection impossible: \(error)")
                }

            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segue.refreshDestinataires" {
            let destinatairesViewController = segue.destination as! DestinatairesViewController
            
            destinatairesViewController.image = self.image
            destinatairesViewController.imageMsq = self.imageMsq
            destinatairesViewController.imageUrl = imageUrl
            destinatairesViewController.imageId = imageId
            destinatairesViewController.imagePrix = imagePrix
            destinatairesViewController.urlFinale = self.urlFinale
            
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
    
    func isValidEmail(testStr:String) -> Bool {
        print("validate emilId: \(testStr)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    func isValidMobile(testStr:String) -> Bool {
        print("validate mobile: \(testStr)")
        let mobileRegEx = "[0-9]*"
        let mobileTest = NSPredicate(format:"SELF MATCHES %@", mobileRegEx)
        let result = mobileTest.evaluate(with: testStr)
        return result
    }

}
