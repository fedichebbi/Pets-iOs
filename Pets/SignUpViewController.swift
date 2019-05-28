//
//  SignUpViewController.swift
//  Pets
//
//  Created by ESPRIT on 15/05/2019.
//  Copyright © 2019 ESPRIT. All rights reserved.
//

import UIKit
import Alamofire

class SignUpViewController: ViewController {

    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signupButton.layer.cornerRadius = 10
        signupButton.layer.shadowColor = UIColor.lightGray.cgColor
        signupButton.layer.shadowOffset = CGSize(width:0,height: 2.0)
        signupButton.layer.shadowRadius = 2.0
        signupButton.layer.shadowOpacity = 1.0
    }
    

    @IBAction func signupAction(_ sender: Any) {
        if ( (password.text?.isEmpty != true) && (username.text?.isEmpty != true) && (phone.text?.isEmpty != true) ){
            
            
            let urlString = "http://41.226.11.252:1180/pets/user/addUser.php"
            let pwd = password.text
            let usrn = username.text
            let phn = self.phone.text
            let passw = "{\"password\":\""+pwd!+"\""
            let usern = passw + ",\"username\":\""+usrn!+"\""
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
            print(request.httpBody)
            Alamofire.request(request).responseJSON {
                (response) in
                switch response.result {
                case .success(let data ):
                    self.signup_success()
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
        } else {
            print("error add user")
        }
        
    }
    
    func signup_success(){
        performSegue(withIdentifier: "signup_success", sender: self)
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
