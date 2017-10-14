//
//  secondViewController.swift
//  iOSTaskTwitter
//
//  Created by Yasser Osama on 10/13/17.
//  Copyright © 2017 Yasser Osama. All rights reserved.
//

import UIKit

class secondViewController: UIViewController {

    let url = "https://api.twitter.com/1.1/followers/ids.json"
    var params = Dictionary<String,String>()
    var clientError: NSError?
    var followersIDs = [Int]()
    
    var client: TWTRAPIClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let userId = Twitter.sharedInstance().sessionStore.session()?.userID else {
            return
        }
        
        self.client = TWTRAPIClient(userID: userId)
        client?.loadUser(withID: userId) { (user, error) in
            if user != nil {
                print("User: \(String(describing: user))")
            } else {
                print("Error: \(String(describing: error))")
            }
        }
        params.updateValue(userId, forKey: "id")
        
        let request = client?.urlRequest(withMethod: "GET", url: url, parameters: params, error: &clientError)
        
        client?.sendTwitterRequest(request!) { (response, data, connectionError) in
            if connectionError != nil {
                print("Error: \(connectionError?.localizedDescription ?? "hi")")
            }
            do {
                guard let json = try JSONSerialization.jsonObject(with: data!, options: []) as? Dictionary<String,Any> else {
                    return
                }
                print("json: \(json)")
                guard let ids = json["ids"] as? [Int] else {
                    return
                }
                self.followersIDs = ids
            } catch let jsonError as NSError {
                print("Json error: \(jsonError.localizedDescription)")
            }
        }
    }
    @IBAction func butssa(_ sender: UIButton) {
        for id in followersIDs {
            client?.loadUser(withID: String(id), completion: { (user, error) in
                if user != nil {
                    print("user: \(user)")
                } else {
                    print("error: \(error)")
                }
            })
        }
    }
    
}
