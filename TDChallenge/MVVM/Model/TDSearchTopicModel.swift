//
//  TDSearchTopicModel.swift
//  TDChallenge
//
//  Created by Akshay Gohel on 2018-09-28.
//  Copyright © 2018 Akshay Gohel. All rights reserved.
//

import Foundation

struct TDTopic {
    let iconUrl: String?
    let text: String?
    let firstURL: String?
    
    init(_ topicDictionary: NSDictionary) {
        if topicDictionary.count > 0 {
            if let iconDict = topicDictionary["Icon"] as? NSDictionary {
                if let topicIcon = iconDict["URL"] as? String {
                    self.iconUrl = topicIcon
                } else {
                    self.iconUrl = ""
                }
            } else {
                self.iconUrl = ""
            }
            
            if let titleString = topicDictionary["FirstURL"] as? String {
                self.firstURL = titleString
            } else {
                self.firstURL = ""
            }
            
            if let subTitleString = topicDictionary["Text"] as? String {
                self.text = subTitleString
            } else {
                self.text = ""
            }
            
        } else {
            self.iconUrl = ""
            self.text = ""
            self.firstURL = ""
        }
    }
}
