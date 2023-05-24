//
//  News.swift
//  
//
//  Created by serdar on 16.05.2023.
//

import Foundation

public struct NewsResult: Decodable {
    public let status: String?
    public let results: [News]?
    public let section: String?
    public let numResults: Int?
    public let lastUpdated: String?
    public let copyright: String?
    
    
    enum CodingKeys: String, CodingKey {
        case status, results, section,copyright
        case lastUpdated = "last_updated"
        case numResults = "num_results"
    }
}


public struct News: Decodable {
    public let title: String?
    public let section: String?
    public let subsection: String?
    public let abstract: String?
    public let byline: String?
    public let publishedDate: String?
    public let updatedDate: String?
    public let url: String?
    public let multimedia: [Media]?
    
    enum CodingKeys: String, CodingKey {
        case title, section, subsection,byline,url,abstract,multimedia
        case publishedDate = "published_date"
        case updatedDate = "updated_date"
    }
}

public struct Media: Decodable{
    public let url: String?
    
    enum CodingKeys: String, CodingKey {
        case url
    }
}
