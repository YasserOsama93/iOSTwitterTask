//
//  AppDelegate.swift
//  iOSTaskTwitter
//
//  Created by Yasser Osama on 10/13/17.
//  Copyright © 2017 Yasser Osama. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
     
        Twitter.sharedInstance().start(withConsumerKey: "pYFdsWvdxNEtR3u9AuNgXqq6A", consumerSecret: "IzELWiVoI1s65M0gHcojElKA2K7RfrK7e7UCMlOWGQjrJ7nHcW")
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return Twitter.sharedInstance().application(app, open: url, options: options)
    }

}

