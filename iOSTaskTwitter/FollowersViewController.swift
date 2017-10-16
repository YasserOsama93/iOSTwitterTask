//
//  secondViewController.swift
//  iOSTaskTwitter
//
//  Created by Yasser Osama on 10/13/17.
//  Copyright © 2017 Yasser Osama. All rights reserved.
//

import UIKit
import Kingfisher

class FollowersViewController: UITableViewController {

    let url = "https://api.twitter.com/1.1/followers/list.json"
    var params = Dictionary<String,String>()
    var clientError: NSError?
    
    var fetchedFollowers = [Dictionary<String,Any>]()
    var client: TWTRAPIClient?
    var selectedUser = Dictionary<String, Any>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableViewAutomaticDimension
        self.refreshControl?.addTarget(self, action: #selector(fetchFollowers), for: UIControlEvents.valueChanged)
        fetchFollowers()
    }
    @IBAction func LogOut(_ sender: UIBarButtonItem) {
        let store = Twitter.sharedInstance().sessionStore
        if let userID = store.session()?.userID {
            store.logOutUserID(userID)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedFollowers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "followerCell", for: indexPath) as! FollowerTableViewCell
        if fetchedFollowers.count > 0 {
            cell.followerName.text = fetchedFollowers[indexPath.row]["name"] as? String
            cell.followerScreenName.text = "@\(fetchedFollowers[indexPath.row]["screen_name"]!)"
            let bio = fetchedFollowers[indexPath.row]["description"] as? String
            if !((bio?.isEmpty)!) {
                cell.followerBio.text = bio
            } else {
                cell.followerBio.isHidden = true
            }
            let imageUrl = URL(string: (fetchedFollowers[indexPath.row]["profile_image_url_https"] as? String)!)
            cell.followerImageView.kf.setImage(with: imageUrl)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let bio = fetchedFollowers[indexPath.row]["description"] as? String
        if !(bio?.isEmpty)! {
            return 150
        } else {
            return 85
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FollowerTableViewCell
        cell.user = fetchedFollowers[indexPath.row]
        selectedUser = fetchedFollowers[indexPath.row]
        performSegue(withIdentifier: "loadUserProfile", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loadUserProfile" {
            let userVC = segue.destination as! UserProfileViewController
            userVC.user = selectedUser
        }
    }
    
    @objc func fetchFollowers() {
        
        guard let userId = Twitter.sharedInstance().sessionStore.session()?.userID else {
            return
        }
        
        self.client = TWTRAPIClient(userID: userId)
        
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
                    guard let users = json["users"] as? [Dictionary<String,Any>] else {
                        return
                    }
                    self.fetchedFollowers = users
                    self.refreshControl?.endRefreshing()
                    self.tableView.reloadData()
                } catch let jsonError as NSError {
                    print("Json error: \(jsonError.localizedDescription)")
                }
            }
            
        }
        
    }
}
