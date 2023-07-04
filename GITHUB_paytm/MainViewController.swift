//
//  MainViewController.swift
//  GITHUB_paytm
//
//  Created by Navdeep on 27/06/2023.
//

import UIKit
struct GitHubUser: Codable {
    let login: String
    let name: String?
    let bio: String?
    let location: String?
    let avatar_url: String?
    let following: Int?
    let followers: Int?
    let public_repos: Int?
    let email: String?
}

struct GitHubRepo: Codable {
    let name: String
    let description: String?
    let language: String?
    let stargazers_count:Int?
    let forks_count:Int?
    let owner: Owner
}
struct Owner: Codable{
    let avatar_url:String?
}

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet var ProfileDataLabel: UILabel!
    @IBOutlet var following: UILabel!
    @IBOutlet var repos: UILabel!
    @IBOutlet var followers: UILabel!
    @IBOutlet var Profileimage: UIImageView!
    @IBOutlet var repotable: UITableView!
    @IBOutlet var Bio: UILabel!
    var userRepos: [GitHubRepo] = []
    var user_ka_naam:String!
//  var contri_ka_naam:String!iska zarrorat nahi hai
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = repotable.cellForRow(at: indexPath)
            performSegue(withIdentifier: "profiletocontri", sender: cell)
        }//it is just a manual way to call sugue but isme hammne ui hi kr diya hai and we are picking name from table label
    
    //This is not working
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "profiletocontri",
//           let destinationVC = segue.destination as? contributorViewController,
//           let selectedRepo = sender as? String {
//            print(selectedRepo,user_ka_naam!)
//            destinationVC.user_ka_naam_contri = user_ka_naam
//            destinationVC.user_ka_repo_contri = selectedRepo
////            print(destinationVC.user_ka_naam_contri!,destinationVC.user_ka_repo_contri!)
//        }
//    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profiletocontri",
           let destinationVC = segue.destination as? contributorViewController,
           let cell = sender as? CustomCell
        {
            //this is just for debugging
            print("helllooooooooooooooooooooooooooo")
            destinationVC.user_ka_naam_contri = user_ka_naam
            //why is this not working
//            destinationVC.user_ka_repo_contri =  repotable.cellForRow(at: indexPath)?.textLabel?.text
            destinationVC.user_ka_repo_contri = cell.CTCLabel.text
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        repotable.register(UINib(nibName:"CustomCell",bundle: nil),forCellReuseIdentifier: "CustomCell")
        repotable.delegate = self
        repotable.dataSource = self
            fetchGitHubUserName(username : user_ka_naam)
            fetchGitUserRepos(username : user_ka_naam)
    }
    
    func fetchGitHubUser(username : String){
        let base_url = "https://api.github.com/"
        let additional_url_of_user = "users/\(username)"
        let final_url_string = base_url + additional_url_of_user
        
        guard let url = URL(string: final_url_string) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("[DATA TASK ERROR: \(error.localizedDescription)]")
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
                let userData = try decoder.decode(GitHubUser.self, from: data)
                
                DispatchQueue.main.async {
                    self.ProfileDataLabel.text = "Username: \(userData.login)\nName: \(userData.name ?? "N/A")\nBio: \(userData.bio ?? "N/A")\nLocation: \(userData.location ?? "N/A")"
                    print("Username: \(userData.login)")
                    print("Name: \(userData.name ?? "N/A")")
                    print("Bio: \(userData.bio ?? "N/A")")
                    print("Location: \(userData.location ?? "N/A")")
                    if let avatar_url = userData.avatar_url {
                                       self.downloadImage(from: avatar_url)
                                   }
                }
            } catch {
                print("[JSON DECODING ERROR: \(error.localizedDescription)]")
            }
        }
        task.resume()
    }
    
    func fetchGitHubUserName(username : String){
        let base_url = "https://api.github.com/"
        let additional_url_of_user = "users/\(username)"
        let final_url_string = base_url + additional_url_of_user
        
        guard let url = URL(string: final_url_string) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("[DATA TASK ERROR: \(error.localizedDescription)]")
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
                let userData = try decoder.decode(GitHubUser.self, from: data)
                
                DispatchQueue.main.async {
                    self.ProfileDataLabel.text = "\(userData.login)"
                    self.followers.text = "\(userData.followers!)\nfollowers"
                    self.following.text = "\(userData.following!)\nfollowing"
                    self.repos.text = "\(userData.public_repos!)\nRepos"
                    print("\(userData.login)")
                    self.Bio.text = "Bio:\(userData.bio ?? "N/A")"
                    if let avatar_url = userData.avatar_url {
                                       self.downloadImage(from: avatar_url)
                                   }
                }
            } catch {
                print("[JSON DECODING ERROR: \(error.localizedDescription)]")
            }
        }
        task.resume()
    }
    
    func fetchGitUserRepos(username :String ){
        let base_url = "https://api.github.com/"
        let additional_user_of_user = "users/\(username)/repos"
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
                let userRepos = try decoder.decode([GitHubRepo].self, from: data)
                
                DispatchQueue.main.async {
//                     Here you build a string with all the repo names
                    let reposString = userRepos.map { "\($0.name): \($0.description ?? "No description")" }.joined(separator: "\n")

                    self.userRepos = userRepos
                    self.repotable.reloadData()
                    
                    // And display it in the label
//                    self.ProfileDataLabel.text = self.ProfileDataLabel.text! + "Repos:\n\(reposString)"
                    print("Repos:\n\(reposString)")
                }
            } catch {
                print("[JSON DECODING ERROR: \(error.localizedDescription)]")
            }
        }
        task.resume()
    }
    func downloadImage(from urlString: String){
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
                    DispatchQueue.main.async {
                        self.Profileimage.image = image
                    }
                }
            }
            task.resume()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userRepos.count
    }
//    This was for basic cell
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
//        cell.textLabel?.text = userRepos[indexPath.row].name
//        return cell
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.CTCLabel.text = userRepos[indexPath.row].name
        cell.des.text = userRepos[indexPath.row].description ?? "No description"
        cell.langauge.text = userRepos[indexPath.row].language ?? "."
        cell.stars.text = "⭐️\(userRepos[indexPath.row].stargazers_count ?? 0)"
        cell.forks.text = "Fork:\(userRepos[indexPath.row].forks_count ?? 0)"
        if let avatar_url = userRepos[indexPath.row].owner.avatar_url {
            self.downloadImage(from: avatar_url,indexi:indexPath)
                       }
        return cell
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
                        let cell = self.repotable.cellForRow(at: index) as! CustomCell
                        cell.CTCImage.image = image
                    }
                    
                }
            }
            task.resume()
        }
    }
    
    
}
