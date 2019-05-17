//
//  MyProfileViewController.swift
//  Pets
//
//  Created by ESPRIT on 01/05/2019.
//  Copyright © 2019 ESPRIT. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import CoreData
import FBSDKCoreKit
import FBSDKLoginKit

class MyProfileViewController: UIViewController {

    
    
    @IBOutlet weak var deleteAccountButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var profile_image: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    var pho = ""
    var id = ""
    var usrn = ""
    var password = ""
    
    var usernamee = ""
    var ide = ""
    let fbLoginManager:FBSDKLoginManager = FBSDKLoginManager()
    
    
    override func viewWillAppear(_ animated: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ConnectedUser")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                print("datacoooore", data)
                let p = data.value(forKey: "phone") as! String
                let u = data.value(forKey: "username") as! String
                let i = data.value(forKey: "id") as! String
                let pwd = data.value(forKey: "password") as! String
                let imgURL = "https://graph.facebook.com/"+pwd+"/picture?width=200&height=200"
                print(imgURL)
                let url = URL(string: imgURL)
                do {
                    let data = try Data(contentsOf: url!)
                    print("imagefbdata",data)
                    profile_image.image = UIImage(data: data)
                    profile_image.layer.borderWidth = 3
                    profile_image.layer.masksToBounds = false
                    profile_image.layer.borderColor = UIColor.white.cgColor
                    profile_image.layer.cornerRadius = profile_image.frame.height/2
                    profile_image.clipsToBounds = true
                }
                catch{
                    print("error")
                }
                
                self.pho = p
                self.id = i
                self.usrn = u
                self.password = pwd
                
                username.text = u
                phone.text = p
            }
        } catch {
            print("failed getData")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.layer.cornerRadius = 10
        saveButton.layer.shadowColor = UIColor.lightGray.cgColor
        saveButton.layer.shadowOffset = CGSize(width:0,height: 2.0)
        saveButton.layer.shadowRadius = 2.0
        saveButton.layer.shadowOpacity = 1.0
        deleteAccountButton.layer.cornerRadius = 10
        deleteAccountButton.layer.shadowColor = UIColor.lightGray.cgColor
        deleteAccountButton.layer.shadowOffset = CGSize(width:0,height: 2.0)
        deleteAccountButton.layer.shadowRadius = 2.0
        deleteAccountButton.layer.shadowOpacity = 1.0
        logoutButton.layer.cornerRadius = 10
        logoutButton.layer.shadowColor = UIColor.lightGray.cgColor
        logoutButton.layer.shadowOffset = CGSize(width:0,height: 2.0)
        logoutButton.layer.shadowRadius = 2.0
        logoutButton.layer.shadowOpacity = 1.0
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ConnectedUser")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let u = data.value(forKey: "username") as! String
                let i = data.value(forKey: "id") as! String
                usernamee = u
                ide = i
            }
        } catch {
            print("failed getData")
        }
    }
    

    @IBAction func saveAction(_ sender: Any) {
        if ( phone.text?.isEmpty != true ){
            
            let ph = phone.text
            
            let urlString = "http://41.226.11.252:1180/pets/user/updateUser.php"
            
            let urn = "{\"username\":\""+usrn+"\""
            let i = urn + ",\"id\":\""+id+"\""
            let phoo = i + ",\"phone\":\""+ph!+"\""
            let psw = phoo + ",\"password\":\""+password+"\""
            let email = psw + ",\"email\":\""+""+"\"}"
            var json = email
            json = String(json.filter { !"\r\n\n\t\r".contains($0) })
            print(json)
            let url = URL(string: urlString)!
            let jsonData = json.data(using: .utf8, allowLossyConversion: false)!
            
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.post.rawValue
            request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            print(request.httpBody)
            Alamofire.request(request).responseJSON {
                (response) in
                if (true){
                    print(response)
                    self.deleteAllCoreData()
                    
                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    let entity = NSEntityDescription.entity(forEntityName: "ConnectedUser", in: context)
                    let newEntity = NSManagedObject(entity: entity!, insertInto: context)
                    
                    newEntity.setValue(self.usrn, forKey: "username")
                    newEntity.setValue(self.password, forKey: "password")
                    newEntity.setValue(self.id, forKey: "id")
                    newEntity.setValue(ph, forKey: "phone")
                    
                    do {
                        try context.save()
                        print("user updated to coreData")
                    } catch {
                        print("failed saving to coreData")
                    }
                }
            }
        } else {
            print("error update user" , Date())
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
    
    func deleteAllCoreData()
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let ReqVar = NSFetchRequest<NSFetchRequestResult>(entityName: "ConnectedUser")
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: ReqVar)
        do { try context.execute(DelAllReqVar) }
        catch { print(error) }
    }

    @IBAction func deleteAccountAction(_ sender: Any) {
        // Create the alert controller
        let alertController = UIAlertController(title: "Delete", message: "Are you sure you want to permanently delete your account " + usernamee + "?", preferredStyle: .alert)
        // Create the actions
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            UIAlertAction in
            print("OK Pressed")
            
            let url = "http://41.226.11.252:1180/pets/user/deleteUser.php?id="+self.id
            Alamofire.request(url).responseJSON{
                response in
                print ("deleted")
            }
            self.deleteAllData()
            self.logout()
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
    
    @IBAction func logoutAction(_ sender: Any) {
        self.deleteAllData()
        self.fbLoginManager.logOut()
        self.logout()
    }
    
    func logout(){
        performSegue(withIdentifier: "logout", sender: self)
    }
    
    func deleteAllData()
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let ReqVar = NSFetchRequest<NSFetchRequestResult>(entityName: "ConnectedUser")
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: ReqVar)
        do { try context.execute(DelAllReqVar) }
        catch { print(error) }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
