//
//  CustomCellForRepoTableTableViewCell.swift
//  Github_user_ios
//
//  Created by Navdeep on 06/07/2023.
//

import UIKit

class CustomCellForRepoTableTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    var images:[String] = ["image1.png","image2.png","image3.png"]
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionViewRepo.delegate = self
        collectionViewRepo.dataSource = self
        collectionViewRepo.register(UINib(nibName:"CollectionViewCellRepoCollectionViewCell",bundle: nil),forCellWithReuseIdentifier: "segmentcellrepo")
    }
    var repoData: GitHubRepo? {
            didSet {
                collectionViewRepo.reloadData()
            }
        }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"segmentcellrepo", for: indexPath) as! CollectionViewCellRepoCollectionViewCell
        
            switch indexPath.item {
            case 0:
                cell.label.text = repoData?.language ?? "N/A"
                cell.image.image = UIImage(named: images[2])
            case 1:
                cell.label.text = "\(repoData?.stargazers_count ?? 0)"
                cell.image.image = UIImage(named: images[0])
            case 2:
                cell.label.text = "\(repoData?.forks_count ?? 0)"
                cell.image.image = UIImage(named: images[1])
            default:
                break
            }

        return cell
    }
    

    @IBOutlet var repoImage: UIImageView!
    @IBOutlet var collectionViewRepo: UICollectionView!
    @IBOutlet var repoDescription: UILabel!
    @IBOutlet var reponame: UILabel!
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension CustomCellForRepoTableTableViewCell:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellwidth = collectionViewRepo.bounds.width
        return CGSize(width: cellwidth/3, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
        
    }
}
