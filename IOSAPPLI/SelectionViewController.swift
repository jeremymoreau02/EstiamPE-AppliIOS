//
//  SelectionViewController.swift
//  IOSAPPLI
//
//  Created by marcel NTOUTOUME-DOUMI on 18/12/2016.
//  Copyright © 2016 Mireille TOULOUBET. All rights reserved.
//

import UIKit
import SQLite

class SelectionViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate,  UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    @IBOutlet weak var imageVue: UIImageView!
    var photos: [Photo] = [Photo]()
    var imageCounter: Int = 0
    var indexPhoto = 0
    var idU: Int64 = 0

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        do{
            let db = try Connection("\(path)/db.sqlite3")
            let panier = Table("panier")
            let id = Expression<Int64>("id")
            let idLivraison = Expression<Int64?>("id_livraison")
            let idUser = Expression<Int64?>("id_user")
            let idAdresse = Expression<Int64?>("id_adresse")
            let nbPhotos = Expression<Int64?>("nb_photos")
            let prixHT = Expression<Double?>("prixHT")
            let prixTTC = Expression<Double?>("prixTTC")
            let fdp = Expression<Double?>("fdp")
            let prixTotal = Expression<Double?>("prixTotal")
            let nomFacturation = Expression<String?>("nomFacturation")
            let prenomFacturation = Expression<String?>("prenomFacturation")
            let cpFacturation = Expression<String?>("cpFacturation")
            let villeFacturation = Expression<String?>("villeFacturation")
            let rueFacturation = Expression<String?>("rueFacturation")
            let status = Expression<String?>("status")
            
            do{
                try db.run(panier.create(ifNotExists: true) { t in     // CREATE TABLE "users" (
                    t.column(id, primaryKey: true) //     "id" INTEGER PRIMARY KEY NOT NULL,
                    t.column(idLivraison)
                    t.column(idUser)
                    t.column(idAdresse)
                    t.column(nbPhotos)
                    t.column(prixHT)
                    t.column(prixTTC)
                    t.column(fdp)
                    t.column(prixTotal)
                    t.column(nomFacturation)
                    t.column(prenomFacturation)
                    t.column(cpFacturation)
                    t.column(villeFacturation)
                    t.column(rueFacturation)
                    t.column(status)
                })
                do {
                    let preferences = UserDefaults.standard
                    idU = Int64.init(preferences.string(forKey: "userId")! as String)!
                    let all = Array(try db.prepare(panier.filter(idUser == idU)))
                    if (all.count == 0){
                        do{
                            let idPanier = try db.run(panier.insert(idUser <- idU))
                            let preferences = UserDefaults.standard
                            preferences.set(idPanier, forKey: "idPanier")
                        }catch{
                            print("insertion impossible: \(error)")
                        }
                        
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
        
    
    }
    
    func imagePickerControllerDidCancel(_ imagePicker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ imagePicker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        let imageURL = info[UIImagePickerControllerReferenceURL] as! NSURL
        let imageName         = imageURL.lastPathComponent
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let photoURL          = NSURL(fileURLWithPath: documentDirectory)
        let localPath         = photoURL.appendingPathComponent(imageName!)
        
        if !FileManager.default.fileExists(atPath: localPath!.path) {
            do {
                try UIImageJPEGRepresentation(chosenImage, 1.0)?.write(to: localPath!)
                print("file saved")
            }catch {
                print("error saving file")
            }
        }
        else {
            print("file already exists")
        }
    
        self.photos.append(Photo(url: imageURL as URL, uiimage: chosenImage))
        
        if let collectionView = collectionView {
            collectionView.reloadData()
        }
        
        dismiss(animated:true, completion: nil) //5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath as IndexPath) as! MyImageCell
        
        var currImage : UIImage = self.photos[self.imageCounter].uiimage
        
       
        cell.image.image = currImage
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SelectionViewController.imageTapped(sender:)))
        cell.image.addGestureRecognizer(tapGesture)
        cell.image.isUserInteractionEnabled = true
        
        self.imageCounter += 1
        if self.imageCounter >= self.photos.count{
            self.imageCounter = 0
        }
        
        return cell
        
        
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
        
    }
    
    func imageTapped(sender : UITapGestureRecognizer) {
        var tapLocation = sender.location(in: self.collectionView)
        var NSIndexPath = self.collectionView.indexPathForItem(at: tapLocation)!
        var url = self.photos[NSIndexPath[1]].url
        
        self.performSegue(withIdentifier: "segue.editphoto", sender: self.photos[NSIndexPath[1]])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segue.editphoto" {
            let editPhotoViewController = segue.destination as! EditPhotoViewController
            
            editPhotoViewController.image = sender as! Photo
            
        }
    }
    
    @IBAction func parametresBtn(_ sender: Any) {
        performSegue(withIdentifier: "segue.userinfos", sender: self)
    }
    
}
