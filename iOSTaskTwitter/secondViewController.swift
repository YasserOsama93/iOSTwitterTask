//
//  secondViewController.swift
//  iOSTaskTwitter
//
//  Created by Yasser Osama on 10/13/17.
//  Copyright © 2017 Yasser Osama. All rights reserved.
//

import UIKit

class secondViewController: UITableViewController {

    let url = "https://api.twitter.com/1.1/followers/list.json"
    var params = Dictionary<String,String>()
    var clientError: NSError?
    var followersIDs = [Int]()
    var fetchedFollowers = [Dictionary<String,Any>]()
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
        params.updateValue("false", forKey: "include_user_entities")
        
        let request = client?.urlRequest(withMethod: "GET", url: url, parameters: params, error: &clientError)
        
        
        client?.sendTwitterRequest(request!) { (response, data, connectionError) in
            if connectionError != nil {
                print("Error: \(connectionError?.localizedDescription ?? "hi")")
            } else {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data!, options: []) as? Dictionary<String,Any> else {
                        return
                    }
                    print("json: \(json)")
                    guard let users = json["users"] as? [Dictionary<String,Any>] else {
                        return
                    }
                    print(users)
                    self.fetchedFollowers = users
                    self.tableView.reloadData()
                } catch let jsonError as NSError {
                    print("Json error: \(jsonError.localizedDescription)")
                }
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedFollowers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "followerCell", for: indexPath)
        if fetchedFollowers.count > 0 {
            cell.textLabel?.text = fetchedFollowers[indexPath.row]["name"] as? String
            cell.detailTextLabel?.text = fetchedFollowers[indexPath.row]["screen_name"] as? String
        }
        return cell
    }
}
