//
//  UIViewControllerExtension.swift
//  HeartRateSample
//
//  Created by Akshay Gohel on 2018-09-28.
//  Copyright © 2018 Akshay Gohel. All rights reserved.
//

import Foundation
import MBProgressHUD

extension UIViewController {
    func showHud(withText text : String, animated: Bool, withIndicator shouldShowIndicator: Bool) {
        if Thread.isMainThread {
            self.showProgressHud(text,animated, shouldShowIndicator)
        } else {
            DispatchQueue.main.async {
                self.showProgressHud(text,animated, shouldShowIndicator)
            }
        }
    }
    
    func hideHud(animated: Bool) {
        if Thread.isMainThread {
            self.hideProgressHud(animated)
        } else {
            DispatchQueue.main.async {
                self.hideProgressHud(animated)
            }
        }
    }
    
    private func showProgressHud(_ text : String, _ animated: Bool, _ shouldShowIndicator: Bool) {
        self.hideHud(animated:false)
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: animated)
        loadingNotification.mode = shouldShowIndicator ? MBProgressHUDMode.indeterminate : MBProgressHUDMode.text
//        loadingNotification.isUserInteractionEnabled = false
        loadingNotification.label.text = text
    }
    
    private func hideProgressHud(_ animated: Bool) {
        MBProgressHUD.hide(for: self.view, animated: animated)
    }
}
