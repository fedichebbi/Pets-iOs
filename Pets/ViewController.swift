//
//  ViewController.swift
//  Pets
//
//  Created by ESPRIT on 10/04/2019.
//  Copyright © 2019 ESPRIT. All rights reserved.
//
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Alamofire
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var _username: UITextField!
    @IBOutlet weak var _password: UITextField!
    @IBOutlet weak var _login_button: UIButton!
    let fbLoginManager:FBSDKLoginManager = FBSDKLoginManager()
    
    var first_name:String?
    var id:String?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //self.getUserData()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ConnectedUser")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if (result.isEmpty)
            {print("result empty")}
            else{
            performSegue(withIdentifier: "login_success", sender: self)
            for data in result as! [NSManagedObject] {
                let u = data.value(forKey: "username") as! String
                let p = data.value(forKey: "password") as! String
                let i = data.value(forKey: "id") as! String
                print ("connected user",u,p,i)
            }
            }
        } catch {
            print("failed getData")
        }
    }
    
    /*override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }*/
    
    @IBAction func login_action(_ sender: Any) {
        let username = _username.text
        let password = _password.text
        let urlString = "http://41.226.11.252:1180/pets/user/userByUsernamePassword.php"
        let json = "{\"username\":\""+username!+"\",\"password\":\""+password!+"\"}"
        
        let url = URL(string: urlString)!
        let jsonData = json.data(using: .utf8, allowLossyConversion: false)!
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        Alamofire.request(request).responseJSON {
            (response) in
            let user = response.result.value as! Dictionary<String,String>
            if (user != Dictionary<String,String>()){
                let usr = user["username"] as! String
                let pwd = user["password"] as! String
                let id = user["id"] as! String
                let pho = user["phone"] as! String
                
                //print(usr)
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName: "ConnectedUser", in: context)
                let newEntity = NSManagedObject(entity: entity!, insertInto: context)
                
                newEntity.setValue(usr, forKey: "username")
                newEntity.setValue(pwd, forKey: "password")
                newEntity.setValue(id, forKey: "id")
                newEntity.setValue(pho, forKey: "phone")
                
                do {
                    try context.save()
                    print("user saved to coreData")
                } catch {
                    print("failed saving to coreData")
                }
                
                self.loginSuccess()
            }
            else {print("wrong data")}
        }
    }
    
    func getData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ConnectedUser")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let u = data.value(forKey: "username") as! String
                let p = data.value(forKey: "password") as! String
                let i = data.value(forKey: "id") as! String
                let ph = data.value(forKey: "phone") as! String
                print (u,p,i,ph)
            }
        } catch {
            print("failed getData")
        }
    }
    
    @IBAction func signup_action(_ sender: Any) {
        performSegue(withIdentifier: "signup", sender: self)
    }
    
    func loginSuccess(){
        performSegue(withIdentifier: "login_success", sender: self)
    }
    
    @IBAction func fbLogin(_ sender: Any) {
        fbDidLogin()
    }
    
    func fbDidLogin(){
        self.fbLoginManager.logIn(withReadPermissions: ["email"], from: self){ (result , error ) in
            if (error == nil)
            {
                let fbLoginResult:FBSDKLoginManagerLoginResult = result!
                if fbLoginResult.grantedPermissions != nil {
                    print("logged in")
                    if (fbLoginResult.grantedPermissions.contains("email")){
                        print ("granted")
                        self.getUserData()
                        //self.fbLoginManager.logOut()
                    }
                }
            }
        }
    }
    
    func fbButtonDidLogout(_ loginButton : FBSDKLoginButton){
        self.fbLoginManager.logOut()
    }
    
    func getUserData(){
        if (FBSDKAccessToken.current() != nil){
            print("token ok")
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "first_name"])
                .start(completionHandler: {(connection , result , error) -> Void in
                    if (error == nil){
                        let faceDic = result as! [String:AnyObject]
                        print (faceDic)
                        self.first_name = faceDic["first_name"] as! String
                        self.id = faceDic["id"] as! String
                        
                        let urlString = "http://41.226.11.252:1180/pets/user/userByUsernamePassword.php"
                        let json = "{\"username\":\""+self.first_name!+"\",\"password\":\""+self.id!+"\"}"
                        
                        let url = URL(string: urlString)!
                        let jsonData = json.data(using: .utf8, allowLossyConversion: false)!
                        
                        var request = URLRequest(url: url)
                        request.httpMethod = HTTPMethod.post.rawValue
                        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
                        request.httpBody = jsonData
                        
                        Alamofire.request(request).responseJSON {
                            (response) in
                            print("reesp",response)
                            let user = response.result.value as! Dictionary<String,String>
                            if (user != Dictionary<String,String>()){
                                let usr = user["username"] as! String
                                let pwd = user["password"] as! String
                                let id = user["id"] as! String
                                let pho = user["phone"] as! String
                                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                                let entity = NSEntityDescription.entity(forEntityName: "ConnectedUser", in: context)
                                let newEntity = NSManagedObject(entity: entity!, insertInto: context)
                                newEntity.setValue(usr, forKey: "username")
                                newEntity.setValue(pwd, forKey: "password")
                                newEntity.setValue(id, forKey: "id")
                                newEntity.setValue(pho, forKey: "phone")
                                do {
                                    try context.save()
                                    print("user saved to coreData")
                                } catch {
                                    print("failed saving to coreData")
                                }
                                self.loginSuccess()
                            }
                            else {
                                print("wrong data")
                                self.fb_success()
                            }
                        }
                        
                        
                        
                    }
                })
        }
        else {
            print("no token")
            /* 10214513343482522 */
        }
    }
    
    
    func fb_success() {
        performSegue(withIdentifier: "fb_success", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fb_success"{
            let PVC = segue.destination as! PhoneViewController
            //let showsDict = allTvShow[indice.row] as! Dictionary<String,Any>
            PVC.id = self.id
            PVC.username = self.first_name
            /*
             DVC.name = showsDict["name"] as? String
             DVC.overview = showsDict["summary"] as! String
             let imageDict = showsDict["image"] as! Dictionary<String,String>
             DVC.image = imageDict["medium"] as! String
             // DVC.image = images[indice.row]
             */
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
