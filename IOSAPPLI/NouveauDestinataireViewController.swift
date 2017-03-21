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
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
     var pickerData: [String] = [String]()
    
    @IBAction func onClickContact(_ sender: Any) {
        let contactPickerViewController = CNContactPickerViewController()
        
        contactPickerViewController.predicateForEnablingContact = NSPredicate(format: "Contacts != nil")
        
        contactPickerViewController.delegate = self
        
        self.present(contactPickerViewController, animated: true, completion: nil)
    }
    
    func contactPicker(picker: CNContactPickerViewController, didSelectContact contact: CNContact) {
        debugPrint(contact)
        navigationController?.popViewController(animated: true)
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
    

}
