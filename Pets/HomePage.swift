//
//  HomePage.swift
//  Pets
//
//  Created by ESPRIT on 10/04/2019.
//  Copyright © 2019 ESPRIT. All rights reserved.
//

import UIKit

class HomePage: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var collectionView: UICollectionView!
    
    let itemLabels = ["Add post", "Lost", "Found", "My profile", "My posts"]
    
    let itemDescriptions = ["Add Lost or Found pets' posts ", "Lost pets' posts", "Found pets' posts", "Edit your profile", "Manage your posts"]
    
    let screenWidth = 150
    
    let itemImages: [UIImage] = [
        UIImage(named: "plus")!,
        UIImage(named: "lost")!,
        UIImage(named: "found")!,
        UIImage(named: "myprofile")!,
        UIImage(named: "myposts")!        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if ( itemLabels[indexPath.item] == "Add post") {
            let width = (self.view.frame.size.width - 11)
            let height = self.view.frame.size.height / 3.5
            return CGSize(width: width, height: height)
        }
        else {
            let width = (self.view.frame.size.width - 11) / 2
            let height = self.view.frame.size.height / 3.5
            return CGSize(width: width, height: height)}
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemLabels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        if ( itemLabels[indexPath.item] == "Add post") {
            cell.itemIcon.center.x = self.view.center.x
            cell.itemLabel.center.x = self.view.center.x
            cell.itemDescription.center.x = self.view.center.x
            cell.separator.center.x = self.view.center.x
        }
        cell.itemLabel.text = itemLabels[indexPath.item]
        cell.itemDescription.text = itemDescriptions[indexPath.item]
        cell.itemIcon.image = itemImages[indexPath.item]
        
        cell.contentView.layer.cornerRadius = 2.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true;
        cell.backgroundColor = UIColor.white
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width:0,height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false;
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
    
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (itemLabels[indexPath.item] == "Lost") {
            //print("aaaaa")
            performSegue(withIdentifier: "toLost", sender: indexPath)
        } else if (itemLabels[indexPath.item] == "Found") {
            performSegue(withIdentifier: "toLost", sender: indexPath)
        }
        else if (itemLabels[indexPath.item] == "Add post") {
            performSegue(withIdentifier: "toAddPost", sender: indexPath)
        }
        else if (itemLabels[indexPath.item] == "My profile") {
            performSegue(withIdentifier: "toProfile", sender: indexPath)
        }
        else if (itemLabels[indexPath.item] == "My posts") {
            performSegue(withIdentifier: "toLost", sender: indexPath)
        }
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLost"{
            let PVC = segue.destination as! PostsViewController
            let indice = sender as! IndexPath
            //let showsDict = allTvShow[indice.row] as! Dictionary<String,Any>
            PVC.type = itemLabels[indice.item]
            /*
             DVC.name = showsDict["name"] as? String
            DVC.overview = showsDict["summary"] as! String
            let imageDict = showsDict["image"] as! Dictionary<String,String>
            DVC.image = imageDict["medium"] as! String
            // DVC.image = images[indice.row]
            */
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
