//
//  NYTimesAPI.swift
//  NyTimesAPI-iOS
//
//  Created by Herock Hasan on 18/5/18.
//  Copyright © 2018 Herock Hasan. All rights reserved.
//

import UIKit
import os
import Foundation

typealias JSON = Any
typealias JSONArray = [JSON]
typealias JSONObject = [String: JSON]

@objc public class NYTimesAPI: NSObject {

    @objc static let sharedInstance = NYTimesAPI()

    private let sessionManager: URLSession = {
        let urlSessionConfiguration: URLSessionConfiguration = URLSessionConfiguration.default
        return URLSession(configuration: urlSessionConfiguration, delegate: nil, delegateQueue: nil)
    }()

    class UrlComponents {
        let path: String // mostpopular/v2/mostviewed/all-sections/30
        let baseUrlString = "https://api.nytimes.com/svc/"
        let apiKey = "IqFlkWL8yWKy2IGoS2sUdUoL8VHIzVVG"
        let searchQuery: String?


        var url: URL {
            var query = [String]()
            if let searchQuery = searchQuery {
                query.append("q=\(searchQuery)")
            }
            query.append("api-key=\(apiKey)")

            guard let composedUrl = URL(string: "?" + query.joined(separator: "&"), relativeTo: NSURL(string: baseUrlString + path + "?") as URL?) else {
                fatalError("Unable to build request url")
            }
            print(composedUrl.absoluteString)
            return composedUrl
        }

        init(path: String, query: String? = nil) {
            self.path = path
            guard var query = query else {
                self.searchQuery = nil
                return
            }

            query = query.replacingOccurrences(of: " ", with: "+")
            self.searchQuery = query
        }
    }

    @objc open func searchArticles(query: String, completion: @escaping (Data? , Error?) -> ()) {
        let urlComponents = UrlComponents(path: "search/v2/articlesearch.json", query: query)
        let request = URLRequest(url: urlComponents.url)

        sessionManager.dataTask(with: request) { (data, response, error) in

            //TODO: Handle error case
            guard error == nil else {
                os_log("Error in network response!", type: .error)
                completion(nil,error)
                return
            }

            if let data = data {
                completion(data,nil)
            }
            }.resume()
    }

    @objc open func fetchFeaturedArticles(completion: @escaping (Data? , Error?) -> ()) {
        let urlComponents = UrlComponents(path: "mostpopular/v2/mostviewed/all-sections/30.json")
        let request = URLRequest(url: urlComponents.url)

        sessionManager.dataTask(with: request) { (data, response, error) in

            //TODO: Handle error case
            guard error == nil else {
                os_log("Error in network response!", type: .error)
                 completion(nil,error)
                return
            }
            

//            var configuredArticles = [FeaturedArticle]()
            if let data = data {
                

                let json = try? JSONSerialization.jsonObject(with: data)
                if let dictionary = json as? JSONObject,
                    let articles = dictionary["results"] as? JSONArray {
                   print(articles)
                    completion(data,nil)
                }
            }
            }.resume()
    }
}

enum Result<T> {
    case success(T)
    case failure(Error)
}

enum APIError : LocalizedError {
    case noData
    case networkError(underlyingError:Error)
    case serializationError(underlyingError:Error)

    public var errorDescription: String? {
        switch self {
        case .noData:
            return NSLocalizedString("MISSING_DATA_ERROR", comment: "Error when server is missing content")
        case let .networkError(underlyingError: error):
            return error.localizedDescription
        case .serializationError(underlyingError: _):
            return NSLocalizedString("DATA_FORMAT_ERROR", comment: "Error related to format of the data")
        }
    }
}
