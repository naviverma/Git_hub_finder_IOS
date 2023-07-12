//
//  Models.swift
//  Github_user_ios
//
//  Created by Navdeep on 06/07/2023.
//

struct GitHubRepoContri: Codable {
    let login: String
    let avatarURL: String?
    let contributions: Int?
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
        case contributions
    }
}

struct GitHubUser: Codable {
    let login: String
    let name: String?
    let bio: String?
    let location: String?
    let avatarURL: String?
    let following: Int?
    let followers: Int?
    let publicRepos: Int?
    let email: String?
    
    enum CodingKeys: String, CodingKey {
        case login
        case name
        case bio
        case location
        case avatarURL = "avatar_url"
        case following
        case followers
        case publicRepos = "public_repos"
        case email
    }
}

struct GitHubRepo: Codable {
    let name: String
    let description: String?
    let language: String?
    let stargazersCount: Int?
    let forksCount: Int?
    let updatedAt: String?
    let visibility: String?
    let owner: Owner
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case language
        case stargazersCount = "stargazers_count"
        case forksCount = "forks_count"
        case updatedAt = "updated_at"
        case visibility
        case owner
    }
}

struct Owner: Codable {
    let avatarURL: String?
    
    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
    }
}

