//
//  HeaderView.swift
//  Github_user_ios
//
//  Created by Navdeep on 04/07/2023.
//

import UIKit

class HeaderView: UIView {
    
    // MARK: - IBOUTLETS
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var bio: UILabel!
    @IBOutlet var username: UILabel!
    @IBOutlet var background: UIImageView!
    
    // MARK: - INSTANCE OF HEADER VIEW
    // This instance is used in Profile View Controller 
    class func instanceFromNib() -> HeaderView {
        return UINib(nibName: "HeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! HeaderView
    }
}
