//
//  TDListViewModel.swift
//  TDChallenge
//
//  Created by Akshay Gohel on 2018-09-28.
//  Copyright © 2018 Akshay Gohel. All rights reserved.
//

import Foundation

class TDListViewModel {
    
    var isFetchedOnce: Bool = false // To restrict fetching again and again on viewDidAppear
    private let urlString = "http://api.duckduckgo.com"///?q=apple&format=json&pretty=1"
    
    private let webService: TDWebServiceProtocol
    
    private var topics: [TDTopic] = [TDTopic]()
    
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingIndicatorClosure: (()->())?
    
    var shouldAllowSegue: Bool = false
    var selectedTopic: TDTopic?

    private var cellViewModels: [TDListCellViewModel] = [TDListCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }

    var isFetching: Bool = false {
        didSet {
            self.updateLoadingIndicatorClosure?()
        }
    }

    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }

    var numberOfCells: Int {
        return cellViewModels.count
    }

    init(webService: TDWebServiceProtocol = TDWebService()) {
        self.webService = webService
    }

    func fetchSearchResultsFromWeb() {
        self.isFetching = true
        self.webService.getSearchResults(url: urlString, parameters: ["q":"apple", "format":"json", "pretty":1], { [weak self] (success, topics, error) in
            self?.isFetching = false
            if let error = error {
                self?.alertMessage = error.rawValue
            } else {
                self?.processTopics(topics)
            }
        })
    }

    func getCellViewModel(atIndexPath indexPath: IndexPath) -> TDListCellViewModel {
        return self.cellViewModels[indexPath.row]
    }

    func createCellViewModel(fromTopic topic: TDTopic) -> TDListCellViewModel {
        return TDListCellViewModel(titleText: topic.firstURL, subTitleText: topic.text, imageUrl: topic.iconUrl)
    }

    private func processTopics(_ topics: [TDTopic]?) {
        if let topics = topics {
            self.topics = topics
            var cellViewModels = [TDListCellViewModel]()
            for topic in topics {
                cellViewModels.append(createCellViewModel(fromTopic: topic))
            }
            self.cellViewModels = cellViewModels
        } else {
            self.alertMessage = TDWebServiceError.internalError.rawValue
        }
    }
    
}

//MARK: - User Action

extension TDListViewModel {
    func userTappedTopic(atIndexPath indexPath: IndexPath) {
        if self.topics.count > indexPath.row {
            let topic = self.topics[indexPath.row]
            self.shouldAllowSegue = true
            self.selectedTopic = topic
        } else {
            self.shouldAllowSegue = false
            self.selectedTopic = nil
            self.alertMessage = "Some error occured"
        }
    }
}
