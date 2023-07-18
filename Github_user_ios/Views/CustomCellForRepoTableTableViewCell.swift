//
//  CustomCellForRepoTableTableViewCell.swift
//  Github_user_ios
//
//  Created by Navdeep on 06/07/2023.
//

import UIKit
import Foundation

class CustomCellForRepoTableTableViewCell: UITableViewCell,UICollectionViewDelegate {
    
    @IBOutlet var repoImage: UIImageView!
    @IBOutlet var collectionViewRepo: UICollectionView!
    @IBOutlet var repoDescription: UILabel!
    @IBOutlet var reponame: UILabel!
    
    static var downloadLabel:Bool = true
    
    
    var repoData: GitHubRepo? {
            didSet {
                collectionViewRepo.reloadData()
            }
        }
    
    var images:[String] = ["image1.png","image2.png","image3.png","image4.png"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionViewRepo.delegate = self
        collectionViewRepo.dataSource = self
        collectionViewRepo.register(UINib(nibName:"CollectionViewCellRepoCollectionViewCell",bundle: nil),forCellWithReuseIdentifier: "segmentcellrepo")
    }
    
    func configure(with repoData: GitHubRepo){
        self.repoData = repoData
        var reponame = repoData.name
        if repoData.visibility == "public" {
            reponame = reponame + " 🌎"
        } else {
            reponame = reponame + " 🔒"
        }
        self.reponame.text = reponame
        self.repoDescription.text = repoData.description ?? "No description"
        if let avatarUrl = repoData.owner.avatarURL{
            let instance = Download()
            if CustomCellForRepoTableTableViewCell.downloadLabel == true{
                instance.downloadImage(from: avatarUrl){
                    data in
                    let image = UIImage(data: data!)
                    
                    DispatchQueue.main.sync{
                        self.repoImage.image = image
                    }
                }
            }
        }
    }
}

extension CustomCellForRepoTableTableViewCell:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellwidth = collectionViewRepo.bounds.width
        return CGSize(width: cellwidth/4, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
        
    }
}

extension CustomCellForRepoTableTableViewCell:UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"segmentcellrepo", for: indexPath) as! CollectionViewCellRepoCollectionViewCell
        
            switch indexPath.item {
            case 0:
                cell.label.text = repoData?.language ?? "N/A"
                cell.image.image = UIImage(named: images[2])
            case 1:
                cell.label.text = "\(repoData?.stargazersCount ?? 0)"
                cell.image.image = UIImage(named: images[0])
            case 2:
                cell.label.text = "\(repoData?.forksCount ?? 0)"
                cell.image.image = UIImage(named: images[1])
            case 3:
                let date = repoData?.updatedAt
                let foramatedDateVar = formatedDate(date!)
                cell.label.text = "\(foramatedDateVar)"
                cell.image.image = UIImage(named: images[3])
            default:
                break
            }

        return cell
    }
    
    func formatedDate(_ dateString:String) -> String{
        
        let formatter = ISO8601DateFormatter()//becasue date is in ISO8601Date format
        
        if let date = formatter.date(from: dateString){
            
            let currentDate = Date()
            let calandar = Calendar.current
            
            let components = calandar.dateComponents([.day,.month,.year,.weekOfMonth,.hour,.minute,.second], from: date, to: currentDate)
            if let years = components.year,years > 0{
                if years > 1 {
                    return "\(years) years ago"
                }
                return "\(years) year ago"
            }
            if let months = components.month,months > 0{
                if months > 1 {
                    return "\(months) months ago"
                }
                return "\(months) month ago"
            }
            if let weeks = components.weekOfMonth,weeks > 0 {
                if weeks > 1 {
                    return "\(weeks) weeks ago"
                }
                return "\(weeks) week ago"
            }
            if let days = components.day,days > 0 {
                if days > 1 {
                    return "\(days) days ago"
                }
                return "\(days) day ago"
            }
            if let hours = components.hour,hours > 0 {
                if hours > 1 {
                    return "\(hours) hours ago"
                }
                return "\(hours) hour ago"
            }
            if let minutes = components.minute,minutes > 0 {
                if minutes > 1 {
                    return "\(minutes) mins ago"
                }
                return "\(minutes) min ago"
            }
            if let secs = components.second,secs > 0 {
                if secs > 1 {
                    return "\(secs) secs ago"
                }
                return "\(secs) sec ago"
            }
            
        }
        return "N/A"
        
    }

    
}

