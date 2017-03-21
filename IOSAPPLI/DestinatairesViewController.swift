//
//  DestinatairesViewController.swift
//  IOSAPPLI
//
//  Created by estiam on 17/03/2017.
//  Copyright © 2017 Mireille TOULOUBET. All rights reserved.
//

import UIKit

class DestinatairesViewController: UIViewController,  UICollectionViewDelegateFlowLayout, UICollectionViewDataSource  {

    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var cellCounter: Int = 0
    var indexCell = 0
    var destinataires: [Destinataire] = [Destinataire]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellDestinataire", for: indexPath as IndexPath) as! DestinataireCellCollectionViewCell
        
        var label : String = self.destinataires[self.cellCounter].nom + self.destinataires[self.cellCounter].prenom
        
        
        cell.labelDetails.text = label
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(DestinatairesViewController.cellTapped(sender:)))
        cell.addGestureRecognizer(tapGesture)
        cell.isUserInteractionEnabled = true
        
        self.cellCounter += 1
        if self.cellCounter >= self.destinataires.count{
            self.cellCounter = 0
        }
        
        return cell
        
        
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.destinataires.count
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
        
    }
    
    func cellTapped(sender : UITapGestureRecognizer) {
        var tapLocation = sender.location(in: self.collView)
        var NSIndexPath = self.collView.indexPathForItem(at: tapLocation)!
        /*var url = self.photos[NSIndexPath[1]].url
        
        self.performSegue(withIdentifier: "segue.editphoto", sender: self.photos[NSIndexPath[1]])*/
    }
    
    

    @IBAction func onClickAjouter(_ sender: Any) {
    }
    

}
