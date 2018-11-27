//
//  UserNotificationCenter.swift
//  Push Notif App
//
//  Created by Andrii Kurshyn on 11/25/18.
//  Copyright © 2018 Andrii Kurshyn. All rights reserved.
//

import Foundation

import UserNotifications
import Firebase

class UserNotificationCenter: NSObject {
    
    static var current = UserNotificationCenter()
    
    var fcmToken: String?
    
    override init() {
        super.init()
        
        UNUserNotificationCenter.current().delegate = self
        
        Messaging.messaging().delegate = self
    }
    
    
    func register() {
        
        UIApplication.shared.registerForRemoteNotifications()
        
    }
    
    func requestAuthorizatio(completion: @escaping ()->()) {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in
            DispatchQueue.main.async {
                completion()
            }
        })
    }
    
}

// MARK: - UNUserNotificationCenter Delegate

extension UserNotificationCenter: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        self.fcmToken = fcmToken
        print("fcmToken \(fcmToken)")
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        
    }
    
}

extension UserNotificationCenter {
    
    static func push(title: String?, text: String?, fcmToken: String) {
        let url = URL(string: "https://fcm.googleapis.com/fcm/send")!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("key=AAAAkxt48wk:APA91bEnh5kDsOjtXHrA521Yib9QcmEFYuDEUTZzHGuJnkzUB2WhS-1ObAZw0mC6cd48tjux_42oJCBvIUw-p0H2Q449VyUm-mXeQQf8jCQzho_AMOviExO_8gXFyXQBK80t8FGnSlK8", forHTTPHeaderField: "Authorization")
        
        var message = [String: Any]()
        message["to"] = fcmToken
        
        var notification = [String: Any]()
        notification["body"] = text ?? "This is an FCM notification message!"
        notification["title"] = title ?? "Push Notif App"
        
        if title?.isEmpty == true && text?.isEmpty == true {
            notification["body"] = "This is an FCM notification message!"
        }
        
        notification["sound"] = ""
        message["notification"] = notification
        
        message["priority"] = "high"
        message["content_available"] = true
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: message, options: .prettyPrinted)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                print("data \(String(data: data, encoding: .utf8) ?? "nil")")
            } else {
                print("error : \(String(describing: error))")
            }
        }
        task.resume()
    }
    
}


// MARK: - UNUserNotificationCenter Delegate

extension UserNotificationCenter: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .badge, .sound])
    }
    
}
