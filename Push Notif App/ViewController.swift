//
//  ViewController.swift
//  Push Notif App
//
//  Created by Andrii Kurshyn on 11/25/18.
//  Copyright © 2018 Andrii Kurshyn. All rights reserved.
//

import UIKit

import Firebase
import FBSDKLoginKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var profilePhoto: UIImageView!
    
    @IBOutlet weak var labelMessageTextField: UITextField!
    @IBOutlet weak var textMessageTextField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var signoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if FBSDKAccessToken.isExist == false {
            self.performSegue(withIdentifier: "login_without_anim", sender: nil)
        } else {
            self.updateFacebookUserInfo()
        }
    }
    
    @IBAction func send(_ sender: UIButton) {
        self.view.endEditing(true)
        
        UserNotificationCenter.current.requestAuthorizatio() {
            if let token = UserNotificationCenter.current.fcmToken {
                UserNotificationCenter.push(title: self.labelMessageTextField.text, text: self.textMessageTextField.text, fcmToken: token)
            }
        }
    }
    
    @IBAction func signout(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if FBSDKAccessToken.isExist {
            FBSDKLoginManager().logOut()
        }
        
        self.performSegue(withIdentifier: "login", sender: nil)
    }

    private func updateFacebookUserInfo() {
        if FBSDKAccessToken.isExist == false { return  }
        
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name, email"])
        let connection = FBSDKGraphRequestConnection()
        
        connection.add(graphRequest, completionHandler: { (connection, result, error) -> Void in
            
            let data = result as? [String : AnyObject]
            
            self.displayName.text = data?["name"] as? String
            
            if let id = data?["id"] as? String {
                self.profilePhoto.setImage(with: "https://graph.facebook.com/\(id)/picture?type=large&return_ssl_resources=1")
            }
        })
        
        connection.start()
    }
    
    // MARK: UITextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

