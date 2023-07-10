import UIKit

class ProfileViewController: UIViewController{
    
    // MARK: - IBOUTLETS
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var segmentController: UISegmentedControl!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var HeaderView: UIView!
    @IBOutlet var repoTable: UITableView!
    @IBOutlet var username: UILabel!
    @IBOutlet var bio: UILabel!
    @IBOutlet var hashtag: UILabel!
    
    // MARK: - Declarations
    var usernamePassedBylogin :String!
    public var userRepos: [GitHubRepo] = []
    var userData: [Int] = []
    var names: [String] = ["Followers","Following","Repos"]
    
    //MARK: - Viewdidload
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Adding Header View for Profile
        let headerView = HeaderView
        repoTable.tableHeaderView = headerView
        
        // MARK: - Registering segment cell
        collectionView.register(UINib(nibName:"CollectionViewCell",bundle: nil),forCellWithReuseIdentifier: "segmentcell")
        repoTable.register(UINib(nibName: "CustomCellForRepoTableTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        
        //MARK: - delegates/datsources assignments
        repoTable.delegate = self
        repoTable.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //MARK - Calling Functions
        fetchGitHubUserName(username : usernamePassedBylogin)
        fetchGitUserRepos(username : usernamePassedBylogin)
        
        //MARK: - Segment controller
        segmentController.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    //MARK: Fetching funcs
    //MARK: UserData
    func fetchGitHubUserName(username : String){
        let base_url = "https://api.github.com/"
        let additional_url_of_user = "users/\(username)"
        let final_url_string = base_url + additional_url_of_user
        
        let insatanceOfApiManager = ApiManager()
        insatanceOfApiManager.hitApi(final_url_string){
            (data,error) in
            do {
                let decoder = JSONDecoder()
                let userData = try decoder.decode(GitHubUser.self, from: data!)
                DispatchQueue.main.async {
                    self.username.text = "\(userData.name ?? "N/A")"
                    self.hashtag.text = "@\(userData.login)"
                    self.bio.text = "Bio:\(userData.bio ?? "N/A")"
                    if let avatar_url = userData.avatar_url {
                        let instance = Download()
                        instance.downloadImage(from: avatar_url){
                            data in
                            let image = UIImage(data: data!)
                            DispatchQueue.main.async {
                                self.profileImage.image = image
                            }
                        }
                    }
                    self.userData.append(userData.followers ?? 0)
                    self.userData.append(userData.following ?? 0)
                    self.userData.append(userData.public_repos ?? 0)
                    self.collectionView.reloadData()
                }
            } catch {
                print("[JSON DECODING ERROR: \(error.localizedDescription)]")
            }
        }
    }
    
    //MARK: Repos
    
    func fetchGitUserRepos(username :String ){
        let base_url = "https://api.github.com/"
        let additional_user_of_user = "users/\(username)/repos"
        let final_url_string = base_url + additional_user_of_user
        let instance = ApiManager()
        instance.hitApi(final_url_string){
            (data,error) in
            do {
                let decoder = JSONDecoder()
                let userRepos = try decoder.decode([GitHubRepo].self, from: data!)
                DispatchQueue.main.async {
                    let reposString = userRepos.map { "\($0.name): \($0.description ?? "No description")" }.joined(separator: "\n")
                    self.userRepos = userRepos
                    self.repoTable.reloadData()
                    print("Repos:\n\(reposString)")
                }
            } catch {
                print("[JSON DECODING ERROR: \(error.localizedDescription)]")
            }
        }
        
    }
    
    //MARK: Function for segment Controller
    
    @objc func segmentChanged(_ sender: UISegmentedControl){
        repoTable.reloadData()
    }
    
    //MARK: overriding viewcontroller funcs
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        repoTable.reloadData()
        collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profiletocontri",
           let destinationVC = segue.destination as? ContributorsViewController,
           let cell = sender as? CustomCellForRepoTableTableViewCell
        {
            destinationVC.usernamePassedByContri = usernamePassedBylogin
            destinationVC.repoNamePassedByContri = cell.reponame.text
        }
    }
}

extension ProfileViewController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellwidth = collectionView.bounds.width
        return CGSize(width: cellwidth/3, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
        
    }
    
}

extension ProfileViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "segmentcell", for: indexPath) as! CollectionViewCell
        if indexPath.item < self.userData.count{//this is needed because this array is getting data from api and that is async
            cell.Value.text = "\(self.userData[indexPath.item])"
        }
        cell.variable.text = "\(self.names[indexPath.item])"
        return cell
    }
    
}

extension ProfileViewController:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        if segmentController.selectedSegmentIndex == 1 {
                return 0
            }
        return userRepos.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCellForRepoTableTableViewCell
        cell.reponame.text = userRepos[indexPath.row].name
        cell.repoDescription.text = userRepos[indexPath.row].description ?? "No description"
        cell.repoData = userRepos[indexPath.row]
        if let avatar_url = userRepos[indexPath.row].owner.avatar_url {
            let instance = Download()
            instance.downloadImage(from: avatar_url,indexi:indexPath){
                data in
                let image = UIImage(data: data!)
                DispatchQueue.main.sync {
                let cell = self.repoTable.cellForRow(at: indexPath) as! CustomCellForRepoTableTableViewCell
                cell.repoImage.image = image
                }
            }
        }
        return cell
    }
    
}

extension ProfileViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 100.0
        }
        return 40.0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1{
            return segmentController
        }
            return collectionView
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = repoTable.cellForRow(at: indexPath)
            performSegue(withIdentifier: "profiletocontri", sender: cell)
        }
    
}

extension ProfileViewController:UICollectionViewDelegate{
    //Nothing till now
}

