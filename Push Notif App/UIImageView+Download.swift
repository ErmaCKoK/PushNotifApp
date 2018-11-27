//
//  UIImageView+Download.swift
//  Push Notif App
//
//  Created by Andrii Kurshyn on 11/25/18.
//  Copyright © 2018 Andrii Kurshyn. All rights reserved.
//

import UIKit

extension UIImageView {
    
    fileprivate struct AssociatedKeys {
        static var task = "UIImageView+Download.task"
        static var url = "UIImageView+Download.url"
    }
    
    fileprivate var task: URLSessionDataTask? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.task) as? URLSessionDataTask }
        set { objc_setAssociatedObject(self, &AssociatedKeys.task, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
    
    fileprivate var url: String? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.url) as? String }
        set { objc_setAssociatedObject(self, &AssociatedKeys.url, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }

    
    func setImage(with url: String?) {
        
        self.reset()
        self.url = url
        
        guard let url = url else { return }
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { (data, response, error) -> Void in
            if url != self.url  { return }
            if let data = data {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
        })
        
        task.resume()
        self.task = task
    }
    
    fileprivate func reset() {
        self.task?.cancel()
        self.url = nil
        self.image = nil
    }
    
}
