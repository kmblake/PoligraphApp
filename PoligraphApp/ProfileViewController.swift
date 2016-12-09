//
//  ProfileViewController.swift
//  PoligraphApp
//
//  Created by Kent Blake on 12/8/16.
//  Copyright © 2016 Silo Busters. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileImage?.layer.cornerRadius = (self.profileImage?.frame.size.width ?? 0.0) / 2
        self.profileImage?.clipsToBounds = true
    }

}
