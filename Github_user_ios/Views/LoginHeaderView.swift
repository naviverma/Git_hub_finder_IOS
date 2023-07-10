//
//  LoginHeaderView.swift
//  Github_user_ios
//
//  Created by Navdeep on 06/07/2023.
//

import UIKit

class LoginHeaderView: UIView {

    @IBOutlet var findButton: UIButton!
    @IBOutlet var image: UIImageView!
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var title: UILabel!
    
    // MARK: - INSTANCE OF HEADER VIEW
    // This instance is used in Profile View Controller
    class func instanceFromNib() -> LoginHeaderView {
        return UINib(nibName: "LoginHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LoginHeaderView
    }
    
    
}
