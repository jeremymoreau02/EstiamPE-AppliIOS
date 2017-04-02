//
//  EditPhotoViewController.swift
//  IOSAPPLI
//
//  Created by estiam on 28/02/2017.
//  Copyright © 2017 Mireille TOULOUBET. All rights reserved.
//

import Foundation
import UIKit

class EditPhotoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var image : Photo = Photo(url: URL(string: "https://www.apple.com")!, uiimage: UIImage())
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image.getImage()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickValider(_ sender: Any) {
        self.performSegue(withIdentifier: "segue.destinataires", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segue.destinataires" {
            let destinatairesViewController = segue.destination as! DestinatairesViewController
            
            destinatairesViewController.image = image
            
        }
    }
    
}
