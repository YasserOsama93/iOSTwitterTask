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
        
        let logInButton = TWTRLogInButton { (session, error) in
            if session != nil {
                print("Session: \(String(describing: session?.userName))")
                self.performSegue(withIdentifier: "loginSuccess", sender: self)
            } else {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        }
        
        logInButton.center = self.view.center
        self.view.addSubview(logInButton)
        
        let client = TWTRAPIClient()
    }
}

