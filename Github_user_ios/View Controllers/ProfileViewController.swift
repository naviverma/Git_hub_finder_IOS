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
    
    var updateTimer:Timer?
    var debugger:Int = 0
    var flag:Bool = true
    
    @IBAction func Follow(_ sender: Any) {
        let alertController = UIAlertController(title: "FOLLOW", message: "This feature is not available yet", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    //making the initial instaces
    static var initialInstance: ProfileViewController?
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Declarations
    var usernamePassedBylogin :String!
    public var userRepos: [GitHubRepo] = []
    var userData: [Int] = [0,0,0,0]
    var names: [String] = ["Followers","Following","Repos","Stars"]
    var totalStars:Int = 0
    
    //MARK: - Viewdidload
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(activityIndicator)
        
        let backgroundView = UIView()
        backgroundView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        backgroundView.backgroundColor = UIColor(white: 0, alpha: 0.5) // semi-transparent black
        backgroundView.center = self.view.center
        
        if ProfileViewController.initialInstance != nil {
            let homeButton = UIBarButtonItem(image: UIImage(named: "home1.png"), style: .plain, target: self, action: #selector(homeButtonTapped))
            self.navigationItem.rightBarButtonItem = homeButton
        }
        if ProfileViewController.initialInstance == nil {
            ProfileViewController.initialInstance = self
        }
        
        //setting the title
        self.title = usernamePassedBylogin
        
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
        
        //MARK - Calling Functions and chaining is done to insure the seq
        
        activityIndicator.startAnimating()
        view.addSubview(backgroundView)
        
        ApiHandling.fetchUser(username: usernamePassedBylogin){
            (result,error) in
            DispatchQueue.main.async {
                if error == "offline" || result == nil {
                    if let bundleURL = Bundle.main.url(forResource: "CashedUserData", withExtension: "geojson") {
                        do {
                            let data = try Data(contentsOf: bundleURL)
                            let userData = try JSONDecoder().decode(GitHubUser.self, from: data)
                            self.updateUIForUser(userData,false)
                        } catch {
                            print("Failed to load or decode data: \(error)")
                        }
                        let alert = UIAlertController(title: "Error", message: "Check your internet.\nThis cashed data.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
                        alert.addAction(UIAlertAction(title: "Leave", style: .default,handler:{
                            action in
                            self.navigationController?.popToRootViewController(animated: true)
                        }))
                        self.present(alert,animated: true,completion: nil)
                    } else {
                        print("Could not find the file")
                    }
                } else {
                    self.updateUIForUser(result!,true)
                }
            }
        
        ApiHandling.fetchUserRepo(username: self.usernamePassedBylogin){
            (result,error) in
            DispatchQueue.main.async {
                if error == "offline" || result == nil {
                    if let bundleURL = Bundle.main.url(forResource: "CashedContributorData", withExtension: "geojson") {
                        do {
                            let data = try Data(contentsOf: bundleURL)
                            let userData = try JSONDecoder().decode([GitHubRepo].self, from: data)
                            self.updateUIForRepos (userData,false)
                        } catch {
                            print("Failed to load or decode data: \(error)")
                        }
                    } else {
                        print("Could not find the file")
                    }

                } else {
                    self.updateUIForRepos(result!,true)
                }
                self.activityIndicator.stopAnimating()
                backgroundView.removeFromSuperview()
            }
        }
    }
        
        
        //MARK: - Segment controller
        segmentController.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            startUpdateTimer()
        }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            updateTimer?.invalidate()
        }

        func startUpdateTimer() {            updateTimer?.invalidate()

            updateTimer = Timer.scheduledTimer(withTimeInterval: 120.0, repeats: true) { [weak self] _ in
                self?.fetchData()
            }
        }

        func fetchData() {
            ApiHandling.fetchUser(username: usernamePassedBylogin) {
                (result, error) in
                DispatchQueue.main.async {
                    if error == "noData" || result == nil {
                        if let bundleURL = Bundle.main.url(forResource: "CashedUserData", withExtension:".geojson"),
                           let data = try? Data(contentsOf: bundleURL){
                            let decoder = JSONDecoder()
                            let userData = try? decoder.decode(GitHubUser.self, from: data)
                            self.updateUIForUser(userData!,false)
                        }
                    } else {
                        self.updateUIForUser(result!,true)
                    }
                }
            }

            ApiHandling.fetchUserRepo(username: self.usernamePassedBylogin) {
                (result, error) in
                DispatchQueue.main.async {
                    if error == "noData" || result == nil {
                    } else {
                        self.updateUIForRepos(result!,true)
                    }
                }
            }
        }

    
    //MARK: Function for segment Controller
    
    @objc func segmentChanged(_ sender: UISegmentedControl){
        repoTable.reloadData()
    }
    
    //MARK: overriding viewcontroller func
    
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
            let truncatedRepoName = String(cell.reponame.text!.dropLast(2))
            destinationVC.repoNamePassedByContri = truncatedRepoName
        }
    }
    
    //Home button Logic
    @objc func homeButtonTapped() {
        guard let initialVC = ProfileViewController.initialInstance else {
            return
        }
            self.navigationController?.popToViewController(initialVC, animated: true)
    }
}

extension ProfileViewController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellwidth = collectionView.bounds.width
        return CGSize(width: cellwidth/4, height: 100)
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
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "segmentcell", for: indexPath) as! CollectionViewCell
            if indexPath.item < self.userData.count , userData.count == 4{//this is needed because this array is getting data from api and that is async
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
        let repoData = userRepos[indexPath.row]
        cell.configure(with: repoData)
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

extension ProfileViewController{
    
    func updateUIForRepos(_ result:[GitHubRepo],_ flagForRepos:Bool){
            var localStars = 0
            if flagForRepos == false{
            CustomCellForRepoTableTableViewCell.downloadLabel = false
            }
            self.userRepos = result
            for repo in self.userRepos {
                localStars += repo.stargazersCount ?? 0
            }
            self.totalStars = localStars
            self.userData[3] = (self.totalStars)
            self.repoTable.reloadData()
            self.collectionView.reloadData()
    }
    
    func updateUIForUser(_ result:GitHubUser,_ flagForImage:Bool){
        
        self.userData = [0,0,0,totalStars]
        self.username.text = "\(result.name ?? "N/A")"
        self.hashtag.text = "@\(result.login )"
        self.bio.text = "Bio:\(result.bio ?? "N/A")"
        
        if flagForImage == true{
            if let avatar_url = result.avatarURL {
                let instance = Download()
                instance.downloadImage(from: avatar_url){
                    data in
                    let image = UIImage(data: data!)
                    DispatchQueue.main.async {
                        self.profileImage.image = image
                    }
                }
            }
        }
            self.userData[0] = result.followers ?? 0
            self.userData[1] = result.following ?? 0
            self.userData[2] = result.publicRepos ?? 0
            self.collectionView.reloadData()
    }
}

