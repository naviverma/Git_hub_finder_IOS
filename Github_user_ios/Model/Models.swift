//
//  Models.swift
//  Github_user_ios
//
//  Created by Navdeep on 06/07/2023.
//

struct GitHubRepoContri: Codable {
    let login: String
    let avatar_url: String?
    let contributions: Int?
}

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

