//
//  ViewController.swift
//  iOSTaskTwitter
//
//  Created by Yasser Osama on 10/13/17.
//  Copyright © 2017 Yasser Osama. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let store = Twitter.sharedInstance().sessionStore
        let sessions = store.existingUserSessions()
        if sessions.count > 0 {
            self.performSegue(withIdentifier: "loginSuccess", sender: self)
        } else {
            let logInButton = TWTRLogInButton { (session, error) in
                if session != nil {
                    print("Session: \(String(describing: session?.userName))")
                    self.performSegue(withIdentifier: "loginSuccess", sender: self)
                    store.save(session!, completion: { (session2, error2 ) in
                        if session2 != nil {
                            print("Session: \(String(describing: session2?.userID))")
                        } else {
                            print("Error: \(String(describing: error2?.localizedDescription))")
                        }
                    })
                } else {
                    print("Error: \(String(describing: error?.localizedDescription))")
                }
            }
            logInButton.center = self.view.center
            self.view.addSubview(logInButton)
        }
    }
}

