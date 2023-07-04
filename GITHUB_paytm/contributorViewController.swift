//
//  contributorViewController.swift
//  GITHUB_paytm
//
//  Created by Navdeep on 27/06/2023.
//

import UIKit

struct GitHubRepoContri: Codable {
    let login: String
    let avatar_url: String?
    let contributions: Int?
}

class contributorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet var contriTable: UITableView!
    var user_ka_naam_contri:String!
    var user_ka_repo_contri:String!
    var userReposContri: [GitHubRepoContri] = []
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userReposContri.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.CTCLabel.text = userReposContri[indexPath.row].login
        if let avatar_url = userReposContri[indexPath.row].avatar_url {
            self.downloadImage(from: avatar_url,indexi:indexPath)
                       }
        cell.des.text = "Contributions:\(userReposContri[indexPath.row].contributions!)"
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contriTable.register(UINib(nibName:"CustomCell",bundle: nil),forCellReuseIdentifier: "CustomCell")
        fetchcontribtors(username:user_ka_naam_contri, repo:user_ka_repo_contri)
    }
    
    func fetchcontribtors(username :String,repo: String){
        let base_url = "https://api.github.com/"
        let additional_user_of_user = "repos/\(username)/\(repo)/contributors"
        let final_url_string = base_url + additional_user_of_user
    
        guard let url = URL(string: final_url_string) else{
            return
        }
        
        let task = URLSession.shared.dataTask(with: url){
            (data,response,error) in
            if let error = error{
                print("[DATA TASK ERROR:\(error.localizedDescription)]")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("[SERVER ERROR]")
                return
            }
            
            guard let data = data else {
                print("No data is received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let userReposContri = try decoder.decode([GitHubRepoContri].self, from: data)
                
                DispatchQueue.main.async {
                    let reposcontriString = userReposContri.map { $0.login }.joined(separator: "\n")
                    self.userReposContri = userReposContri
                    self.contriTable.reloadData()
                    
                    
                    // And display it in the label
//                    self.ProfileDataLabel.text = self.ProfileDataLabel.text! + "Repos:\n\(reposString)"
                    print("Repos:\n\(reposcontriString)")
                }
            } catch {
                print("[JSON DECODING ERROR: \(error.localizedDescription)]")
            }
        }
        task.resume()
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
                        let cell = self.contriTable.cellForRow(at: index) as! CustomCell
                        cell.CTCImage.image = image
                    }
                    
                }
            }
            task.resume()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        print(sender)
        //this was for debugging
        if segue.identifier == "contritoprofile",
           let destinationVC = segue.destination as? MainViewController,
           let cell = sender as? CustomCell
        {
            destinationVC.user_ka_naam = cell.CTCLabel.text
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = contriTable.cellForRow(at: indexPath)
        performSegue(withIdentifier: "contritoprofile", sender: cell)
    }
}
