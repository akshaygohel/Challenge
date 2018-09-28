//
//  TDWebServiceProtocol.swift
//  TDChallenge
//
//  Created by Akshay Gohel on 2018-09-28.
//  Copyright © 2018 Akshay Gohel. All rights reserved.
//

import Foundation

protocol TDWebServiceProtocol {
    func getSearchResults(url urlString: String, parameters: [String: Any], _ completion: @escaping ( _ success: Bool, _ topics: [TDTopic]?, _ error: TDWebServiceError? ) -> ())
}
