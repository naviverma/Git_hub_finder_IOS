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
    
    var contribution: GitHubRepoContri? {
            didSet {
                configureCell()
            }
        }

    func configureCell() {
        guard let contribution = self.contribution else { return }
        self.contriName.text = contribution.login
        self.contriNo.text = "Contributions:\(contribution.contributions ?? 0)"
        
        if let avatar_url = contribution.avatarURL {
            let instance = Download()
            instance.downloadImage(from: avatar_url) {
                data in
                let image = UIImage(data: data!)
                DispatchQueue.main.sync {
                    self.contriImage.image = image
                }
            }
        }
    }
}
