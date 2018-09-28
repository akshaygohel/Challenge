//
//  TDWebService.swift
//  TDChallenge
//
//  Created by Akshay Gohel on 2018-09-28.
//  Copyright © 2018 Akshay Gohel. All rights reserved.
//

import Foundation

enum TDWebServiceError: String, Error {
    case networkError = "Seems you are not connected to internet."
    case internalError = "Something went wrong. Please try again later"
}

class TDWebService: TDWebServiceProtocol {
    let TOPICS_TO_SHOW = 20
    
    func getSearchResults(url urlString: String, parameters: [String: Any], _ completion: @escaping (_ success: Bool, _ topics: [TDTopic]?, _ error: TDWebServiceError?) -> ()) {
        if urlString.count > 0 {
            var components = URLComponents(string: urlString)!
            components.queryItems = parameters.map { (arg) -> URLQueryItem in
                let (key, value) = arg
                if let value = value as? Int {
                    return URLQueryItem(name: key, value: "\(value)")
                } else if let value = value as? Double {
                    return URLQueryItem(name: key, value: "\(value)")
                } else {
                    return URLQueryItem(name: key, value: value as? String)
                }
            }
            components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
            if let url = components.url {
                let session = URLSession.shared;
                let loadTask = session.dataTask(with: url) { (data, response, error) in
                    if let errorResponse = error {
                        completion(false, nil, TDWebServiceError.init(rawValue: errorResponse.localizedDescription))
                    } else if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode != 200 {
                            let errorResponse = NSError(domain: "Domain", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey : "Http error occured"])
                            completion(false, nil, TDWebServiceError.init(rawValue: errorResponse.localizedDescription))
                        } else {
//                            print(data)
                            let topicsArray = self.parseResponse(data: data)
                            completion(true, topicsArray, nil)
                        }
                    }
                }
                loadTask.resume()
                return
            }
        }
        completion(false, nil, TDWebServiceError.internalError)
    }

    private func parseResponse(data: Data?) -> [TDTopic] {
        var topics = [TDTopic]()
        
        if let data = data {
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with:data, options: [])
                if let jsonDict =  jsonResponse as? NSDictionary {
                    guard let relatedTopics = jsonDict["RelatedTopics"] as? Array<NSDictionary> else {
                        return topics
                    }
                    for relatedTopic in relatedTopics {
                        if let topicsInRelatedTopic = relatedTopic["Topics"] as? Array<NSDictionary> {
                            for topic in topicsInRelatedTopic {
                                topics.append(self.createTopicFromData(topic))
                                if topics.count >= TOPICS_TO_SHOW {
                                    return topics
                                }
                            }
                        } else {
                            topics.append(self.createTopicFromData(relatedTopic))
                            if topics.count >= TOPICS_TO_SHOW {
                                return topics
                            }
                        }
                    }
                }
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        
        return topics
    }
    
    func createTopicFromData(_ topicDictionary: NSDictionary) -> TDTopic {
        return TDTopic.init(topicDictionary)
    }
    
}
