//
//  SettingsViewController.swift
//  Pets
//
//  Created by ESPRIT on 01/05/2019.
//  Copyright © 2019 ESPRIT. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: ViewController {

    @IBOutlet weak var deleteAccountButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
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
        self.deleteAllData()
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
    
}
