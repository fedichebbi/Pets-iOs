//
//  PostCell.swift
//  Pets
//
//  Created by ESPRIT on 24/04/2019.
//  Copyright © 2019 ESPRIT. All rights reserved.
//

import UIKit

//1. delegate method
protocol MyCellDelegate: AnyObject {
    func btnDeleteTapped(cell: PostCell)
    func callButtonTapped(cell: PostCell)
}

class PostCell: UICollectionViewCell {
    
    @IBOutlet weak var deleteButton: UIButton!
    
    //2. create delegate variable
    weak var delegate: MyCellDelegate?
    
    @IBAction func deleteAction(_ sender: Any) {
        print("delete from cell")
        //4. call delegate method
        //check delegate is not nil with `?`
        delegate?.btnDeleteTapped(cell: self)
    }
    
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var postTag: UIImageView!
    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var postIcon: UIImageView!
    @IBOutlet weak var postDescription: UITextView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postTitle: UILabel!
    
    @IBAction func callAction(_ sender: Any) {
        delegate?.callButtonTapped(cell: self)
    }
    
}
