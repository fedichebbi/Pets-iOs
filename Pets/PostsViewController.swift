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

class PostsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var type:String?
    
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
    
    var posts:NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Alamofire.request("http://41.226.11.252:1180/pets/post/allPosts.php").responseJSON{
            response in
            let postsArray = (response.result.value as! NSArray)
            var posts:NSMutableArray = []
            for post in postsArray {
                let postDict = post as! Dictionary<String,Any>
                let postType = postDict["type"] as! String
                print(postType)
                //print(postDict["town"] as! String)
                if (postType == self.type!.lowercased()){
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! PostCell
        
        let postdict = posts[indexPath.row] as! Dictionary<String,Any>
        cell.postTitle.text = postdict["town"] as? String
        cell.postDescription.text = postdict["description"] as? String
        cell.postDate.text = postdict["date"] as? String
        let url = postdict["petImage"] as? String
        let imageUrl = "http://41.226.11.252:1180/pets/post/" + url!
        cell.postImage.af_setImage(withURL: URL(string: imageUrl)!)
        
        let posttype = postdict["type"] as! String
        
        if (posttype == "lost") {
            cell.postIcon.image = itemImages[0]
            cell.postTag.image = itemTags[0]
        } else {
            cell.postIcon.image = itemImages[1]
            cell.postTag.image = itemTags[1]
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
        
        return cell
    }
    


}
