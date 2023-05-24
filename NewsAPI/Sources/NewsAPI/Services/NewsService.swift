//
//  NewsService.swift
//  
//
//  Created by serdar on 17.05.2023.
//

import Foundation
import Alamofire

public enum SectionAPIURL: String, CaseIterable {
    case home = "home"
    case arts = "arts"
    case automobiles = "automobiles"
    case books = "books"
    case business = "business"
    case fashion = "fashion"
    case food = "food"
    case health = "health"
    case insider = "insider"
    case magazine = "magazine"
    case movies = "movies"
    case nyregion = "nyregion"
    case obituaries = "obituaries"
    case opinion = "opinion"
    case politics = "politics"
    case realestate = "realestate"
    case science = "science"
    case sports = "sports"
    case sundayreview = "sundayreview"
    case technology = "technology"
    case theater = "theater"
    case tMagazine = "t-magazine"
    case travel = "travel"
    case upshot = "upshot"
    case us = "us"
    case world = "world"
    var baseUrlString: String {
        return "https://api.nytimes.com/svc/topstories/v2"
    }
    /*
     This should be in the environment variables but
     I put it here so you don't have any problems running my project.
     */
    var apiKey: String {
        return "tHxFbkyYS8c1geYwUQaLTTuy8vWD2upr"
    }
    var urlString: String {
        let section = self.rawValue
        return "\(baseUrlString)/\(section).json?api-key=\(apiKey)"
    }
}

public protocol TopNewsServiceProtocol: AnyObject {
    func fetchTopNews(section:SectionAPIURL, completion: @escaping (Result<[News], Error>) -> Void)
}

public class TopNewsService: TopNewsServiceProtocol {
    
    public init() {}
    
    public func fetchTopNews(section:SectionAPIURL, completion: @escaping (Result<[News], Error>) -> Void) {
        
        let urlString = section.urlString
        AF.request(urlString).responseData { response in
            switch response.result {
            case .success(let data):
                let decoder = Decoders.dateDecoder
                do {
                    let response = try decoder.decode(TopNewsResponse.self, from: data)
                    completion(.success(response.results))
                } catch {
                    print("********** JSON DECODE ERROR *******")
                }
            case .failure(let error):
                print("**** GEÇİCİ BİR HATA OLUŞTU: \(error.localizedDescription) ******")
            }
        }
    }
}
