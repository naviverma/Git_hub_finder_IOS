//
//  CustomCell.swift
//  GITHUB_paytm
//
//  Created by Navdeep on 02/07/2023.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet var langauge: UILabel!
    @IBOutlet var CTCLabel: UILabel!
    @IBOutlet var des: UILabel!
    @IBOutlet var stars: UILabel!
    @IBOutlet var CTCImage: UIImageView!
    @IBOutlet var forks: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
            
        
            self.contentView.layer.borderWidth = 1.5
            self.contentView.layer.borderColor = UIColor.systemTeal.cgColor
            self.contentView.layer.cornerRadius = 20
            self.layer.shadowColor = UIColor.systemTeal.cgColor
            self.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
            self.layer.shadowRadius = 20.0
            self.layer.shadowOpacity = 1.0
            self.layer.masksToBounds = false
            self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
            self.contentView.backgroundColor = .white
        }



}
