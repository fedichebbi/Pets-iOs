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

class MyProfileViewController: ViewController {

    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        saveButton.layer.cornerRadius = 10
        saveButton.layer.shadowColor = UIColor.lightGray.cgColor
        saveButton.layer.shadowOffset = CGSize(width:0,height: 2.0)
        saveButton.layer.shadowRadius = 2.0
        saveButton.layer.shadowOpacity = 1.0
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
