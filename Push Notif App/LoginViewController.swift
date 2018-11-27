//
//  LoginViewController.swift
//  Push Notif App
//
//  Created by Andrii Kurshyn on 11/25/18.
//  Copyright © 2018 Andrii Kurshyn. All rights reserved.
//

import UIKit
import FBSDKLoginKit

extension FBSDKAccessToken {
    static var isExist: Bool {
        return FBSDKAccessToken.current() != nil && FBSDKAccessToken.current().tokenString != nil
    }
}

class LoginViewController: UIViewController {

    @IBOutlet weak var fbLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func fbLogin(_ sender: UIButton) {
        if FBSDKAccessToken.isExist {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        FBSDKLoginManager().logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if FBSDKAccessToken.isExist == false { return }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
