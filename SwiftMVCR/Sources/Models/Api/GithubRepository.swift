//
//  GitHubRepository.swift
//  SwiftMVCR
//
//  Created by 林　翼 on 2018/11/09.
//  Copyright © 2018年 Tsubasa Hayashi. All rights reserved.
//

import Foundation

struct GitHubRepository: Codable {
    let id: Int
    let fullName: String
    let description: String
    let stargazersCount: Int
    let url: String

    private enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case description
        case stargazersCount = "stargazers_count"
        case url = "html_url"
    }
}

struct SearchRepositoriesResponse: Codable {
    let items: [GitHubRepository]
}
