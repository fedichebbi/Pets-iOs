//
//  PhoneViewController.swift
//  Pets
//
//  Created by ESPRIT on 16/05/2019.
//  Copyright © 2019 ESPRIT. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class PhoneViewController: UIViewController {

    @IBOutlet weak var SubmitButton: UIButton!
    @IBOutlet weak var phoneTF: UITextField!
    var id:String?
    var username:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SubmitButton.layer.cornerRadius = 10
        SubmitButton.layer.shadowColor = UIColor.lightGray.cgColor
        SubmitButton.layer.shadowOffset = CGSize(width:0,height: 2.0)
        SubmitButton.layer.shadowRadius = 2.0
        SubmitButton.layer.shadowOpacity = 1.0
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func fb_to_app(_ sender: Any) {
        if (phoneTF.text?.isEmpty != true) {
            
            
            let urlString = "http://41.226.11.252:1180/pets/user/addUser.php"
            let pwd = self.id
            let usrn = self.username
            let phn = phoneTF.text
            
            let passw = "{\"password\":\""+pwd!+"\""
            let usern = passw + ",\"username\":\""+usrn!+"\""
            //let id = usern + ",\"id\":\""+"68"+"\""
            let phone = usern + ",\"phone\":\""+phn!+"\""
            let email = phone + ",\"email\":\""+""+"\""
            let token = email + ",\"token\":\""+""+"\"}"
            var json = token
            json = String(json.filter { !"\r\n\n\t\r".contains($0) })
            print(json)
            let url = URL(string: urlString)!
            let jsonData = json.data(using: .utf8, allowLossyConversion: false)!
            
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.post.rawValue
            request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            //print(request.httpBody)
            Alamofire.request(request).responseJSON {
                (response) in
                if (true){
                    print(response)
                    let user = response.result.value as! Dictionary<String,Any>
                    
                    
                      var  idusr = user["id"] as! Int
                    
                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    let entity = NSEntityDescription.entity(forEntityName: "ConnectedUser", in: context)
                    let newEntity = NSManagedObject(entity: entity!, insertInto: context)
                    
                    newEntity.setValue(usrn, forKey: "username")
                    newEntity.setValue(pwd, forKey: "password")
                    newEntity.setValue(String(idusr), forKey: "id")
                    newEntity.setValue(phn, forKey: "phone")
                    
                    do {
                        try context.save()
                        print("user saved to coreData")
                    } catch {
                        print("failed saving to coreData")
                    }
                    self.fb_to_app()
                }
            }
        } else {
            print("error add user id fb")
        }    }
    
    
    func fb_to_app() {
        performSegue(withIdentifier: "fb_to_app", sender: self)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
