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
    
    
}
