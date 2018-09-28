//
//  TDDetailWebViewController.swift
//  TDChallenge
//
//  Created by Akshay Gohel on 2018-09-28.
//  Copyright © 2018 Akshay Gohel. All rights reserved.
//

import UIKit
import WebKit

class TDDetailWebViewController: UIViewController, WKNavigationDelegate {
    
    var topicUrl: String?
    private var webView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let webConfiguration = WKWebViewConfiguration()
        self.webView = WKWebView(frame: .zero, configuration: webConfiguration)
        self.webView?.navigationDelegate = self
        //        self.webView?.isUserInteractionEnabled = false
        self.view.addSubview(self.webView!)
        
        if let webView = self.webView {
            self.webView?.translatesAutoresizingMaskIntoConstraints = false
            let leadingConstraint = NSLayoutConstraint(item: webView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)
            let trailingConstraint = NSLayoutConstraint(item: webView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0)
            let topConstraint = NSLayoutConstraint(item: webView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0)
            let bottomConstraint = NSLayoutConstraint(item: webView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
            NSLayoutConstraint.activate([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
        }
        
        self.webView?.stopLoading()
        if let topicUrl = self.topicUrl {
            if let url = URL.init(string: topicUrl) {
                self.webView?.load(URLRequest.init(url: url))
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.showHud(withText: "Loading...", animated: true, withIndicator: true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.hideHud(animated: true)
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.hideHud(animated: true)
    }
}
