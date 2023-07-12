//
//  APIHandling.swift
//  Github_user_ios
//
//  Created by Navdeep on 12/07/2023.
//

import Foundation

protocol APIInterfaceProtocol {
    static func fetchUser(username: String, completionHandler: @escaping (_ result: GitHubUser?, _ error: String?) -> Void)

    static func fetchUserRepo(username: String, completionHandler: @escaping (_ result: [GitHubRepo]?, _ error: String?) -> Void)

    static func fetchContributors(username: String, repoName: String, completionHandler: @escaping (_ result: [GitHubRepoContri]?, _ error: String?) -> Void)
}

class ApiHandling: APIInterfaceProtocol{
    static func fetchUser(username: String, completionHandler: @escaping (GitHubUser?, String?) -> Void) {
        let base_url = "https://api.github.com/"
        let additional_url_of_user = "users/\(username)"
        let final_url_string = base_url + additional_url_of_user
        
        let insatanceOfApiManager = ApiManager()
        insatanceOfApiManager.hitApi(final_url_string){
            (data,error) in
            do {
                if error != nil || data == nil{
                    completionHandler(nil,"noData")
                }
                else{
                    let decoder = JSONDecoder()
                    let userData = try decoder.decode(GitHubUser.self, from: data!)
                    DispatchQueue.main.async {
                        completionHandler(userData,nil)
                    }
                }
            } catch {
                print("[JSON DECODING ERROR: \(error.localizedDescription)]")
            }
        }
    }

    static func fetchUserRepo(username: String, completionHandler: @escaping ([GitHubRepo]?, String?) -> Void) {
        let base_url = "https://api.github.com/"
        let additional_user_of_user = "users/\(username)/repos"
        let final_url_string = base_url + additional_user_of_user
        let instance = ApiManager()
        instance.hitApi(final_url_string){
            (data,error) in
            do {
                if error != nil || data == nil{
                    completionHandler(nil,"noData")
                }
                else{
                    let decoder = JSONDecoder()
                    let userRepos = try decoder.decode([GitHubRepo].self, from: data!)
                    DispatchQueue.main.async {
                        completionHandler(userRepos,nil)
                    }
                }
            } catch {
                print("[JSON DECODING ERROR: \(error.localizedDescription)]")
            }
        }
    }

    static func fetchContributors(username: String, repoName: String, completionHandler: @escaping ([GitHubRepoContri]?, String?) -> Void) {
        let base_url = "https://api.github.com/"
        let additional_user_of_user = "repos/\(username)/\(repoName)/contributors"
        let final_url_string = base_url + additional_user_of_user
        
        let instance = ApiManager()
        instance.hitApi(final_url_string){
            (data,error) in
            do {
                let decoder = JSONDecoder()
                let userReposContri = try decoder.decode([GitHubRepoContri].self, from: data!)
                DispatchQueue.main.async {
                    completionHandler(userReposContri,nil)
                }
            } catch {
                print("[JSON DECODING ERROR: \(error.localizedDescription)]")
            }
        }

    }
}

