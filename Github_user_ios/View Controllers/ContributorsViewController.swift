import UIKit

class ContributorsViewController:  UIViewController{
    
    @IBOutlet var contriHeader: UIView!
    @IBOutlet var contriTable: UITableView!
    @IBOutlet var segmentControllerFiles: UISegmentedControl!
    @IBOutlet var codeBaseHeader: UIView!
    var usernamePassedByContri: String!
    var repoNamePassedByContri: String!
    var userReposContri: [GitHubRepoContri] = []
    var userReposFiles: [GitRepoFiles] = []
    var acivity = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        acivity.hidesWhenStopped = true
        acivity.center = view.center
        view.addSubview(acivity)
        
        let backgroundView = UIView()
        backgroundView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        backgroundView.backgroundColor = UIColor(white: 0, alpha: 0.5) // semi-transparent black
        backgroundView.center = self.view.center
        
        self.view.addSubview(backgroundView)
        acivity.startAnimating()
        
        let homeButton = UIBarButtonItem(image: UIImage(named: "home1.png"), style: .plain, target: self, action: #selector(homeButtonTapped))
        
        self.navigationItem.rightBarButtonItem = homeButton
        contriTable.register(UINib(nibName: "TableViewCellContri", bundle: nil), forCellReuseIdentifier: "CustomCell")
        ApiHandling.fetchContributors(username: usernamePassedByContri, repoName: repoNamePassedByContri) { (result,error) in
            self.updateUIForContri(result!)
            self.acivity.stopAnimating()
            backgroundView.removeFromSuperview()
            
            ApiHandling.fetchRepoFiles(username: self.usernamePassedByContri, repoName: self.repoNamePassedByContri,additional: nil){
                (result,error) in
                self.updateUIForFiles(result!)
                self.acivity.stopAnimating()
                backgroundView.removeFromSuperview()
            }
        }
        
        title = "Contributors"
        let headerView = contriHeader
        contriTable.tableHeaderView = headerView
        
        segmentControllerFiles.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl){
        contriTable.reloadData()
        if segmentControllerFiles.selectedSegmentIndex == 1 {
            let headerView = codeBaseHeader
            contriTable.tableHeaderView = headerView
        }
        else{
            let headerView = contriHeader
            contriTable.tableHeaderView = headerView
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segmentControllerFiles.selectedSegmentIndex == 1 {
            if segue.identifier == "contritofile",
               let destinationVC = segue.destination as?
                RepoViewController,
               let cell = sender as? TableViewCellContri{
                destinationVC.usernamePassed = self.usernamePassedByContri
                destinationVC.reponamePassed = self.repoNamePassedByContri
                destinationVC.additionalPassed =
                cell.contriName.text
            }
            
            }
        else{
            if segue.identifier == "contritoprofile",
               let destinationVC = segue.destination as? ProfileViewController,
               let cell = sender as? TableViewCellContri
            {
                destinationVC.usernamePassedBylogin = cell.contriName.text
            }
        }
    }
    
    @objc func homeButtonTapped() {
        guard let initialVC = ProfileViewController.initialInstance else {
            return
        }
            self.navigationController?.popToViewController(initialVC, animated: true)
    }
}

extension ContributorsViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentControllerFiles.selectedSegmentIndex == 1 {
            return userReposFiles.count
            }
        return userReposContri.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! TableViewCellContri
        if segmentControllerFiles.selectedSegmentIndex == 1 {
            cell.files = userReposFiles[indexPath.row]
            }
        else{
            cell.contribution = userReposContri[indexPath.row]
        }
        return cell
    }
}

extension ContributorsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segmentControllerFiles.selectedSegmentIndex == 1 {
            let cell = contriTable.cellForRow(at: indexPath)
            performSegue(withIdentifier: "contritofile", sender: cell)
            }
        else{
            let cell = contriTable.cellForRow(at: indexPath)
            performSegue(withIdentifier: "contritoprofile", sender: cell)
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            return segmentControllerFiles
        }
        return nil
        }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 40.0
        }
        return 0
    }
}

extension ContributorsViewController{
    func updateUIForContri(_ result: [GitHubRepoContri]){
        self.userReposContri = result
        self.contriTable.reloadData()
    }
    
    func updateUIForFiles(_ result: [GitRepoFiles]){
        self.userReposFiles = result
        self.contriTable.reloadData()
    }
}
