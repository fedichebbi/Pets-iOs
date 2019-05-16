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

class MyProfileViewController: UIViewController {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    var pho = ""
    var id = ""
    var usrn = ""
    var password = ""
    
    
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
                    self.deleteAllData()
                    
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
    
    func deleteAllData()
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let ReqVar = NSFetchRequest<NSFetchRequestResult>(entityName: "ConnectedUser")
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: ReqVar)
        do { try context.execute(DelAllReqVar) }
        catch { print(error) }
    }

}
