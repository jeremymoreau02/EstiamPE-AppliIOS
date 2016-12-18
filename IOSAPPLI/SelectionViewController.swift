//
//  SelectionViewController.swift
//  IOSAPPLI
//
//  Created by marcel NTOUTOUME-DOUMI on 18/12/2016.
//  Copyright © 2016 Mireille TOULOUBET. All rights reserved.
//

import UIKit

class SelectionViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var imageVue: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func prendrePhotoBoutton(_ sender: AnyObject)
    {
        if UIImagePickerController.isSourceTypeAvailable (UIImagePickerControllerSourceType.camera)
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    
    
    @IBAction func importerPhotoBoutton(_ sender: AnyObject)
    {
         if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)
         {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        //let image = UIImagePickerController ()
        //image.delegate = self
        
        //image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        //image.allowsEditing = false
        
        //self.present(image, animated: true)
        //{
            //Après complet
        //}
    //}
    
    //func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    //{
        //if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        //{
            //imageVue.image = image
        //}
            
        //else
        //{
            //Message d'erreur
        //}
        
        //self.dismiss(animated: true, completion: nil)
        
    //}
    
    }
}
