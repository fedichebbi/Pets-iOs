//
//  SettingsViewController.swift
//  Pets
//
//  Created by ESPRIT on 01/05/2019.
//  Copyright © 2019 ESPRIT. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class SettingsViewController: UIViewController {

    @IBOutlet weak var deleteAccountButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    var username = ""
    var id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
                username = u
                id = i
            }
        } catch {
            print("failed getData")
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
    @IBAction func logoutAction(_ sender: Any) {
        self.deleteAllData()
        self.logout()
    }
    @IBAction func deleteAccountAction(_ sender: Any) {
        // Create the alert controller
        let alertController = UIAlertController(title: "Delete", message: "Are you sure you want to permanently delete your account " + username + "?", preferredStyle: .alert)
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
    
}
