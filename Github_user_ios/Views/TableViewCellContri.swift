//
//  TableViewCellContri.swift
//  Github_user_ios
//
//  Created by Navdeep on 07/07/2023.
//

import UIKit

class TableViewCellContri: UITableViewCell {

    @IBOutlet var contriNo: UILabel!
    @IBOutlet var contriName: UILabel!
    @IBOutlet var contriImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
