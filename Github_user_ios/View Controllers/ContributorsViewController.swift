import UIKit

class ContributorsViewController:  UIViewController{
    
    @IBOutlet var contriHeader: UIView!
    @IBOutlet var contriTable: UITableView!
    
    var usernamePassedByContri: String!
    var repoNamePassedByContri: String!
    var userReposContri: [GitHubRepoContri] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contriTable.register(UINib(nibName: "TableViewCellContri", bundle: nil), forCellReuseIdentifier: "CustomCell")
        fetchcontribtors(username: usernamePassedByContri, repo: repoNamePassedByContri)
        let headerView = contriHeader
        contriTable.tableHeaderView = headerView
    }
    
    func fetchcontribtors(username :String,repo: String){
        let base_url = "https://api.github.com/"
        let additional_user_of_user = "repos/\(username)/\(repo)/contributors"
        let final_url_string = base_url + additional_user_of_user
    
        let instance = ApiManager()
        instance.hitApi(final_url_string){
            (data,error) in
            do {
                let decoder = JSONDecoder()
                let userReposContri = try decoder.decode([GitHubRepoContri].self, from: data!)
                
                DispatchQueue.main.async {
                    let reposcontriString = userReposContri.map { $0.login }.joined(separator: "\n")
                    self.userReposContri = userReposContri
                    self.contriTable.reloadData()
                    print("Repos:\n\(reposcontriString)")
                }
            } catch {
                print("[JSON DECODING ERROR: \(error.localizedDescription)]")
            }
        }
    }
    func downloadImage(from urlString: String,indexi index:IndexPath){
        if let url = URL(string: urlString){
            let task = URLSession.shared.dataTask(with: url){(data,response,error) in
                if let error = error{
                    print("[DATA TASK ERROR: \(error.localizedDescription)]")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,(200...299).contains(httpResponse.statusCode)else{
                    print("[SERVER ERROR]")
                    return
                }
                guard let data = data else{
                    print("No data is received")
                    return
                }
                
                do{
                    let image = UIImage(data: data)
                    DispatchQueue.main.sync {
                        let cell = self.contriTable.cellForRow(at: index) as! TableViewCellContri
                        cell.contriImage.image = image
                    }
                    
                }
            }
            task.resume()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "contritoprofile",
           let destinationVC = segue.destination as? ProfileViewController,
           let cell = sender as? TableViewCellContri
        {
            destinationVC.usernamePassedBylogin = cell.contriName.text
        }
    }
}

extension ContributorsViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userReposContri.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! TableViewCellContri
        cell.contriName.text = userReposContri[indexPath.row].login
        if let avatar_url = userReposContri[indexPath.row].avatar_url {
            let instance = Download()
            instance.downloadImage(from: avatar_url,indexi:indexPath){
                data in
                let image = UIImage(data: data!)
                DispatchQueue.main.sync {
                    let cell = self.contriTable.cellForRow(at: indexPath) as! TableViewCellContri
                    cell.contriImage.image = image
                    
                }
            }
        }
        cell.contriNo.text = "Contributions:\(userReposContri[indexPath.row].contributions!)"
        return cell
    }
}

extension ContributorsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = contriTable.cellForRow(at: indexPath)
        performSegue(withIdentifier: "contritoprofile", sender: cell)
    }
}
