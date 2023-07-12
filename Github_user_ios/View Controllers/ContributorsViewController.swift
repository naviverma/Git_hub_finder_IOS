import UIKit

class ContributorsViewController:  UIViewController{
    
    @IBOutlet var contriHeader: UIView!
    @IBOutlet var contriTable: UITableView!
    
    var usernamePassedByContri: String!
    var repoNamePassedByContri: String!
    var userReposContri: [GitHubRepoContri] = []
    
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
            
        }
        title = "Contributors"
        let headerView = contriHeader
        contriTable.tableHeaderView = headerView
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "contritoprofile",
           let destinationVC = segue.destination as? ProfileViewController,
           let cell = sender as? TableViewCellContri
        {
            destinationVC.usernamePassedBylogin = cell.contriName.text
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
        return userReposContri.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! TableViewCellContri
        cell.contribution = userReposContri[indexPath.row]
        return cell
    }
}

extension ContributorsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = contriTable.cellForRow(at: indexPath)
        performSegue(withIdentifier: "contritoprofile", sender: cell)
    }
}

extension ContributorsViewController{
    func updateUIForContri(_ result: [GitHubRepoContri]){
        self.userReposContri = result
        self.contriTable.reloadData()
    }
}
