//
//  AddPostViewController.swift
//  Pets
//
//  Created by ESPRIT on 01/05/2019.
//  Copyright © 2019 ESPRIT. All rights reserved.
//
import UIKit
import Alamofire
import AlamofireImage

class AddPostViewController: ViewController, UIPickerViewDelegate, UIPickerViewDataSource , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var petTypePicker: UISegmentedControl!
    @IBOutlet weak var postTypePicker: UISegmentedControl!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var uploadImageButton: UIButton!
    @IBOutlet weak var petDescription: UITextField!
    @IBOutlet weak var townPickerView: UIPickerView!
    
    private let towns = ["Ariena", "Beja", "Benarous", "Bizerte", "Gabes", "Gafsa", "Jendouba", "Kairouan", "Kasserine", "Kebili", "Kef", "Mahdia", "Manouba", "Medenine", "Monastir", "Nabeul", "Sfax", "Sidibouzid", "Siliana", "Sousse", "Tataouine", "Tozeur", "Tunis", "Zaghouan"]
    let imagePicker = UIImagePickerController()
    var petType = ""
    var postType = ""
    var selectedTown = ""
    var imageURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        self.townPickerView.delegate = self
        self.townPickerView.dataSource = self
        addButton.layer.cornerRadius = 10
        addButton.layer.shadowColor = UIColor.lightGray.cgColor
        addButton.layer.shadowOffset = CGSize(width:0,height: 2.0)
        addButton.layer.shadowRadius = 2.0
        addButton.layer.shadowOpacity = 1.0
        uploadImageButton.layer.cornerRadius = 10
        uploadImageButton.layer.shadowColor = UIColor.lightGray.cgColor
        uploadImageButton.layer.shadowOffset = CGSize(width:0,height: 2.0)
        uploadImageButton.layer.shadowRadius = 2.0
        uploadImageButton.layer.shadowOpacity = 1.0
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return towns.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let valueSelected = towns[row] as String
        selectedTown = valueSelected
        print ("selected town" , selectedTown, valueSelected)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return towns[row]
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        imageView.image = selectedImage
        let imageData:NSData = selectedImage.pngData()! as NSData
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        imageURL = strBase64
        //imageURL = String(strBase64.filter { !" \n\t\r".contains($0) })
        //print("my base64 : " + strBase64)
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func postTypeAction(_ sender: Any) {
        postType = postTypePicker.titleForSegment(at: postTypePicker.selectedSegmentIndex)!
        switch postTypePicker.selectedSegmentIndex
        {
        case 0:
            print("First Segment Selected", postType)
            
        case 1:
            print("Second Segment Selected", postType)
        default:
            break
        }
    }
    
    @IBAction func petTypeAction(_ sender: Any) {
        petType = petTypePicker.titleForSegment(at: petTypePicker.selectedSegmentIndex)!
        switch petTypePicker.selectedSegmentIndex
        {
        case 0:
            print("First Segment Selected", petType)
        case 1:
            print("Second Segment Selected", petType)
        case 2:
            print("third Segment Selected", petType)
        default:
            break
        }
    }
    
    @IBAction func selectImage(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func addPost(_ sender: Any) {
        if ( (petDescription.text?.isEmpty != true) && (imageURL.isEmpty != true) && (selectedTown.isEmpty != true) ){
            print("description & image & town are not empty")
            print ("posttype" , postTypePicker.selectedSegmentIndex)
            print ("petType" , postTypePicker.selectedSegmentIndex)
            print("description", petDescription.text!)
            print("selected town", selectedTown)
            let desc = petDescription.text
            var postType = ""
            if (postTypePicker.selectedSegmentIndex == 0)
            {postType = "found"}
            else
            {postType = "lost"}
            let urlString = "http://41.226.11.252:1180/pets/post/addPost.php"
            let now = Date()
            let descri = "{\"description\":\""+desc!+"\""
            let pet = descri + ",\"petImage\":\""+imageURL+"\""
            let type = pet + ",\"type\":\""+postType+"\""
            let user = type + ",\"user_id\":\"60\""
            let petType = user + ",\"petType\":\""+"cat"+"\""
            let town = petType + ",\"town\":\""+selectedTown+"\""
            let dates = town + ",\"date\":\""+"2000-06-09"+"\"}"
            var json = dates
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
                }
            }
        } else {
            print("daaaaaate" , Date())
        }
        
    }
    
    
}
