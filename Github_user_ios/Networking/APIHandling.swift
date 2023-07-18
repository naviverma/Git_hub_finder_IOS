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
    
    static func fetchRepoFiles(username: String,repoName:String ,additional:String?, completionHandler:@escaping(_ result: [GitRepoFiles]?,_ error:String?)-> Void)
    
    static func fetchCode(username: String,repoName:String,additional:String? ,completionHandler:@escaping(_ result: GitCode?,_ error:String?)-> Void)
}

class ApiHandling: APIInterfaceProtocol{
    static func fetchCode(username: String, repoName: String,additional:String?, completionHandler: @escaping (GitCode?, String?) -> Void) {
        let baseURL = "https://api.github.com/"
        var additionalURLString = "repos/\(username)/\(repoName)/contents/"
        if additional != nil{
            additionalURLString = additionalURLString + additional!
        }
        let finalURLString = baseURL + additionalURLString
        let instance = ApiManager()
        instance.hitApi(finalURLString.replacingOccurrences(of: " ", with: "%20")){
            (data,error,situation) in
            do {
                let decoder = JSONDecoder()
                let userReposFiles = try decoder.decode(GitCode.self, from: data!)
                DispatchQueue.main.async {
                    completionHandler(userReposFiles,nil)
                }
            } catch {
                completionHandler(nil,nil)
                print("[JSON DECODING ERROR Code: \(error.localizedDescription)]")
            }
        }

    }
    
    static func fetchRepoFiles(username: String, repoName: String,additional: String?, completionHandler: @escaping ([GitRepoFiles]?, String?) -> Void) {
        let baseURL = "https://api.github.com/"
        var additionalURLString = "repos/\(username)/\(repoName)/contents/"
        if additional != nil{
            additionalURLString = additionalURLString + additional!
        }
        let finalURLString = baseURL + additionalURLString
        let instance = ApiManager()
        instance.hitApi(finalURLString.replacingOccurrences(of: " ", with: "%20")){
            (data,error,situation) in
            do {
                let decoder = JSONDecoder()
                let userReposFiles = try decoder.decode([GitRepoFiles].self, from: data!)
                DispatchQueue.main.async {
                    completionHandler(userReposFiles,nil)
                }
            } catch {
                completionHandler(nil,nil)
                print("[JSON DECODING ERROR 2: \(error.localizedDescription)]")
            }
        }

    }
    
    static func fetchUser(username: String, completionHandler: @escaping (GitHubUser?, String?) -> Void) {
        let baseURL = "https://api.github.com/"
        let additionalURL = "users/\(username)"
        let finalURLString = baseURL + additionalURL
        
        let insatanceOfApiManager = ApiManager()
        insatanceOfApiManager.hitApi(finalURLString){
            (data,error,situation) in
            do {
                if error != nil || data == nil{
                    if situation == "response error"{
                        completionHandler(nil,"wrongUsername")
                    }
                    else{
                        completionHandler(nil,"offline")
                    }
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
        let baseURL = "https://api.github.com/"
        let addistionalURL = "users/\(username)/repos"
        let finalURLString = baseURL + addistionalURL
        let instance = ApiManager()
        instance.hitApi(finalURLString){
            (data,error,situation) in
            do {
                if error != nil || data == nil{
                    if situation == "response error"{
                        completionHandler(nil,"wrongUsername")
                    }
                    else{
                        completionHandler(nil,"offline")
                    }
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
        let baseURL = "https://api.github.com/"
        let additionalURLString = "repos/\(username)/\(repoName)/contributors"
        let finalURLString = baseURL + additionalURLString
        
        let instance = ApiManager()
        instance.hitApi(finalURLString){
            (data,error,situation) in
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

