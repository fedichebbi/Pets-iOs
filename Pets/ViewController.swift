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
class ViewController: UIViewController {
    
    @IBOutlet weak var _username: UITextField!
    @IBOutlet weak var _password: UITextField!
    @IBOutlet weak var _login_button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
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
                print(usr)
                self.loginSuccess()
            }
            else {print("wrong data")}
        }
    }
    
    
    @IBAction func signup_action(_ sender: Any) {
        performSegue(withIdentifier: "signup", sender: self)
    }
    
    func loginSuccess(){
        performSegue(withIdentifier: "login_success", sender: self)
    }
    
    @IBAction func fbLogin(_ sender: Any) {
        let fbLoginManager:FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self){ (result , error ) in
            if (error == nil){
                let fbLoginResult:FBSDKLoginManagerLoginResult = result!
                if fbLoginResult.grantedPermissions != nil {
                    print("logged in")
                    if (fbLoginResult.grantedPermissions.contains("email")){
                        print ("granted")
                        self.getUserData()
                        fbLoginManager.logOut()
                    }
                }
            }
            
        }
    }
    func fbButtonDidLogout(_ loginButton : FBSDKLoginButton){
        
    }
    func getUserData(){
        if (FBSDKAccessToken.current() != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "email"])
                .start(completionHandler: {(connection , result , error) -> Void in
                    if (error == nil){
                        let faceDic = result as! [String:AnyObject]
                        print (faceDic)
                        let email = faceDic["email"] as! String
                        print (email)
                    }
                })
        }
    }
}
