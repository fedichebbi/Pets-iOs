//
//  PostsViewController.swift
//  Pets
//
//  Created by ESPRIT on 24/04/2019.
//  Copyright © 2019 ESPRIT. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import CoreData

class PostsViewController: UIViewController, MyCellDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func btnDeleteTapped(cell: PostCell) {
        let indexPath = self.collectionView.indexPath(for: cell)
        print("index paaaaaath",indexPath!.row)
        // Create the alert controller
        let alertController = UIAlertController(title: "Delete", message: "Do you really want to delete this post?", preferredStyle: .alert)
        // Create the actions
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            UIAlertAction in
            print("OK Pressed")
            
            let postdict = self.posts[indexPath!.row] as! Dictionary<String,Any>
            let postid = postdict["id"] as? String
            print("postid", postid!)
            
            let url = "http://41.226.11.252:1180/pets/post/deletePost.php?id="+postid!
            
            Alamofire.request(url).responseJSON{
            response in
            print ("deleted")
            self.posts.removeObject(at: indexPath!.row)
            self.collectionView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            print("Cancel Pressed")
        }
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    func callButtonTapped(cell: PostCell) {
        let indexPath = self.collectionView.indexPath(for: cell)
        // Create the alert controller
        let alertController = UIAlertController(title: "Call", message: "Are you sure you want to call this number?", preferredStyle: .alert)
        // Create the actions
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            UIAlertAction in
            print("OK Pressed")
            
            let postdict = self.posts[indexPath!.row] as! Dictionary<String,Any>
            let postUser = postdict["user_id"] as! Dictionary<String,Any>
            let userNumber = postUser["phone"] as? String
            print("userphone", userNumber!)
            let num = String(userNumber!.filter { !"\r\n\n\t\r".contains($0) })
            self.dialNumber(number: num)

        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            print("Cancel Pressed")
        }
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    func dialNumber(number : String) {
        if let url = URL(string: "tel://\(number)"),
            UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            print("errrrror phone call")
        }
    }
    
    
    var type:String?
    var userId = ""
    var hisPosts = false
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let itemTags: [UIImage] = [
        UIImage(named: "l")!,
        UIImage(named: "f")!
    ]
    
    let items = ["1", "2"]
    let itemImages: [UIImage] = [
        UIImage(named: "tag_pink")!,
        UIImage(named: "tag_green")!
    ]
    
    var posts:NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ConnectedUser")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let i = data.value(forKey: "id") as! String
                userId = i
            }
        } catch {
            print("failed getData")
        }
        
        Alamofire.request("http://41.226.11.252:1180/pets/post/allPosts.php").responseJSON{
            response in
            let postsArray = (response.result.value as! NSArray)
            var posts:NSMutableArray = []
            for post in postsArray {
                let postDict = post as! Dictionary<String,Any>
                let postType = postDict["type"] as! String
                let userDict = postDict["user_id"] as! Dictionary<String,Any>
                let user = userDict["id"] as! String
                print(user)
                //print(postDict["town"] as! String)
                if (self.type == "My posts") {
                    if (user == self.userId) {
                        posts.add(post)
                        self.hisPosts = true
                    }
                }
                else if (postType == self.type!.lowercased()){
                    print("adada")
                    posts.add(post)
                }
                // names[i]=tvShowDict["name"] as! String
            }
            self.posts = posts
            self.collectionView.reloadData()        //seasonImg.image = UIImage(named: image!)
        /*seasonImg.af_setImage(withURL: URL(string: image!)!)
        summary.text = overview!*/
        // Do any additional setup after loading the view.
    }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    /*@IBAction func deleteAction(_ sender: Any) {
        print("delete from pvc")
        // Create the alert controller
        let alertController = UIAlertController(title: "Delete", message: "Do you really want to delete this post?", preferredStyle: .alert)
        // Create the actions
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            UIAlertAction in
            print("OK Pressed")
            
            /*let url = "http://41.226.11.252:1180/pets/post/deletePost.php?id="+self.userId
            Alamofire.request(url).responseJSON{
                response in
                print ("deleted")
                self.collectionView.reloadData()
            }*/
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            print("Cancel Pressed")
        }
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }*/
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! PostCell
        
        let postdict = posts[indexPath.row] as! Dictionary<String,Any>
        
        cell.postDescription.text = postdict["description"] as? String
        cell.postDate.text = postdict["date"] as? String
        let url = postdict["petImage"] as? String
        let imageUrl = "http://41.226.11.252:1180/pets/post/" + url!
        cell.postImage.af_setImage(withURL: URL(string: imageUrl)!)
        
        
        
        cell.postImage.layer.cornerRadius = 10
        cell.postImage.clipsToBounds = true
        
        let tow = postdict["town"] as? String
        let posttype = postdict["type"] as! String
        var petType = postdict["petType"] as! String
        
        if (petType == "other" || petType == "Other") {
            petType = "animal"
        }
        
        if (posttype == "lost") {
            //cell.postIcon.image = itemImages[0]
            //cell.postTag.image = itemTags[0]
            cell.postTitle.text = "Lost " + petType + " near " + tow!
        } else {
            //cell.postIcon.image = itemImages[1]
            //cell.postTag.image = itemTags[1]
            cell.postTitle.text = "Found " + petType + " near " + tow!
        }
        //let title = posts[indexPath.row] as! Dictionary<String,Any>
        
        //cell.postTitle.text = title
        /*cell.postDescription.text = items[indexPath.item]
        cell.postDate.text = items[indexPath.item]
        cell.postImage.image = itemImages[indexPath.item]
        cell.postIcon.image = itemImages[indexPath.item]*/
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
        
        cell.callButton.layer.cornerRadius = 10
        cell.callButton.layer.shadowColor = UIColor.lightGray.cgColor
        cell.callButton.layer.shadowOffset = CGSize(width:0,height: 2.0)
        cell.callButton.layer.shadowRadius = 2.0
        cell.callButton.layer.shadowOpacity = 1.0
        
        if (hisPosts) {
            cell.deleteButton.isHidden = false
        } else {
            cell.deleteButton.isHidden = true
        }
        
        cell.delegate = self
        return cell
    }
    


}
