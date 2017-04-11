//
//  EditPhotoViewController.swift
//  IOSAPPLI
//
//  Created by estiam on 28/02/2017.
//  Copyright © 2017 Mireille TOULOUBET. All rights reserved.
//

import Foundation
import UIKit
import SQLite

class EditPhotoViewController: UIViewController, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate,  UICollectionViewDelegateFlowLayout, UICollectionViewDataSource  {
    
    @IBOutlet weak var formatPicker: UIPickerView!
    var image : Photo = Photo(url: URL(string: "https://www.apple.com")!, uiimage: UIImage())
    var imageMsq: UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var collectionMasques: UICollectionView!
    var masques: [Masks] = [Masks]()
    var dims: [Dimensions] = [Dimensions]()
    var orientation: String = ""
    
    var masquesDisplay: [Masks] = [Masks]()
    var imagesMasques: [UIImage] = [UIImage]()
    
    var imageCounter: Int = 0
    
    var urlFinale: String?
    
    override func viewDidLoad() {
        
        
        self.formatPicker.delegate = self
        self.formatPicker.dataSource = self
    
        imageView.image = image.getImage()
        
        if( image.getImage().size.height < image.getImage().size.width){
            orientation = "paysage"
        }else if( image.getImage().size.height > image.getImage().size.width){
            orientation = "portrait"
        }else{
            orientation = "carré"
        }
        
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        print(path)
        do{
            let db = try Connection("\(path)/db.sqlite3")
            let dimensionTable = Table("dimension")
            let idCol = Expression<Int64>("id")
            let nameCol = Expression<String?>("name")
            let widthCol = Expression<Int64?>("width")
            let heightCol = Expression<Int64?>("height")
            
            do{
                try db.run(dimensionTable.create(ifNotExists: true) { t in     // CREATE TABLE "users" (
                    t.column(idCol, primaryKey: true)
                    t.column(nameCol, defaultValue: "")
                    t.column(widthCol, defaultValue: 0)
                    t.column(heightCol, defaultValue: 0)
                    
                })
                
                do {
                    let all = Array(try db.prepare(dimensionTable))
                    for dim in all{
                        if(orientation == "paysage"){
                            if(dim[heightCol]! < dim[widthCol]!){
                                var d = Dimensions()
                                d.height = dim[heightCol]!
                                d.id = dim[idCol]
                                d.name = dim[nameCol]!
                                d.width = dim[widthCol]!
                                dims.append(d)

                            }
                        }else if(orientation == "portait"){
                            if(dim[heightCol]! > dim[widthCol]!){
                                var d = Dimensions()
                                d.height = dim[heightCol]!
                                d.id = dim[idCol]
                                d.name = dim[nameCol]!
                                d.width = dim[widthCol]!
                                dims.append(d)

                            }
                        }else{
                            if(dim[heightCol]! == dim[widthCol]!){
                                var d = Dimensions()
                                d.height = dim[heightCol]!
                                d.id = dim[idCol]
                                d.name = dim[nameCol]!
                                d.width = dim[widthCol]!
                                dims.append(d)

                            }
                        }
                    }
                    formatPicker.reloadAllComponents()
                    
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
        
        do{
            let db = try Connection("\(path)/db.sqlite3")
            let maskTable = Table("mask")
            let idCol = Expression<Int64>("id")
            let DimensionIdCol = Expression<Int64?>("DimensionId")
            let filePathCol = Expression<String?>("filePath")
            let nameCol = Expression<String?>("name")
            let priceCol = Expression<Double?>("price")
            
            do{
                try db.run(maskTable.create(ifNotExists: true) { t in     // CREATE TABLE "users" (
                    t.column(idCol, primaryKey: true) //     "id" INTEGER PRIMARY KEY NOT NULL,
                    t.column(DimensionIdCol, defaultValue: 0)
                    t.column(filePathCol, defaultValue: "")
                    t.column(nameCol, defaultValue: "")
                    t.column(priceCol, defaultValue: 0)
                    
                    
                })
                
                do {
                    let all = Array(try db.prepare(maskTable))
                    for mask in all{
                        var m = Masks()
                        m.id = mask[idCol]
                        m.DimensionId = mask[DimensionIdCol]!
                        m.filePath = mask[filePathCol]!
                        m.name = mask[nameCol]!
                        m.price = mask[priceCol]!
                        masques.append(m)
                    }
                    collectionMasques.reloadData()
                    
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
        
        for masque in masques{
            if(masque.DimensionId == dims[0].id){
                masquesDisplay.append(masque)
            }
        }
        
        collectionMasques.reloadData()
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dims.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dims[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(dims[row])
        masquesDisplay.removeAll()
        for masque in masques{
            if(masque.DimensionId == dims[row].id){
                
                masquesDisplay.append(masque)
            }
        }
        
        collectionMasques.reloadData()
        // Do any additional setup after loading the view.
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickValider(_ sender: Any) {
        
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        
        let result = formatter.string(from: date)
       
            let imageData = NSData(data:UIImagePNGRepresentation(imageMsq!)!)
            let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            var docs: String = paths[0]
            let fullPath = docs + "/" + result + ".png"
            print(fullPath)
            let result2 = imageData.write(toFile: fullPath, atomically: true)
        urlFinale = fullPath
        
        
        self.performSegue(withIdentifier: "segue.destinataires", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segue.destinataires" {
            let destinatairesViewController = segue.destination as! DestinatairesViewController
            
            destinatairesViewController.urlFinale = urlFinale
            destinatairesViewController.image = image
        }
    }
    
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionMasques.dequeueReusableCell(withReuseIdentifier: "cellMasque", for: indexPath as IndexPath) as! MyImageCell
        
        var currImage : String = self.masquesDisplay[self.imageCounter].filePath
        
        let catPictureURL = URL(string: "http://193.70.40.193:3000/" + currImage)!
        
        let session = URLSession(configuration: .default)
        
        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
        let downloadPicTask = session.dataTask(with: catPictureURL) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading cat picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded cat picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        cell.image.image = UIImage(data: imageData)
                        self.imagesMasques.append(UIImage(data: imageData)!)
                        // Do something with your image.
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        
        downloadPicTask.resume()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EditPhotoViewController.imageTapped(sender:)))
        cell.image.addGestureRecognizer(tapGesture)
        cell.image.isUserInteractionEnabled = true
        
        self.imageCounter += 1
        if self.imageCounter >= self.masquesDisplay.count{
            self.imageCounter = 0
        }
        
        return cell
        
        
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.masquesDisplay.count
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 70, height: 70)
        
    }
    
    func imageTapped(sender : UITapGestureRecognizer) {
        var tapLocation = sender.location(in: self.collectionMasques)
        var NSIndexPath = self.collectionMasques.indexPathForItem(at: tapLocation)!
        var url = self.masques[NSIndexPath[1]].filePath
        

                        let maskImage = imagesMasques[NSIndexPath[1]]
                        let maskRef = maskImage.cgImage;
                        
                        let mask = CGImage(
                            maskWidth: (maskRef?.width)!,
                            height: maskRef!.height,
                            bitsPerComponent: maskRef!.bitsPerComponent,
                            bitsPerPixel: maskRef!.bitsPerPixel,
                            bytesPerRow: maskRef!.bytesPerRow,
                            provider: maskRef!.dataProvider!,
                            decode: nil,
                            shouldInterpolate: true)
                        let masked: CGImage? = self.image.uiimage.cgImage?.masking(mask!)
                        if(masked != nil){
                            let maskedImage: UIImage? = UIImage(cgImage: masked!)
                            imageMsq = maskedImage
                            self.imageView.image = maskedImage
       
            }
         self.imageView.image = imageMsq
    }
    
}
