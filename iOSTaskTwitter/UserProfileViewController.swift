//
//  UserProfileViewController.swift
//  iOSTaskTwitter
//
//  Created by Yasser Osama on 10/14/17.
//  Copyright © 2017 Yasser Osama. All rights reserved.
//

import UIKit
import Kingfisher

class UserProfileViewController: TWTRTimelineViewController {

    //MARK: Outlets
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    //MARK: Properties
    let url = "https://api.twitter.com/1.1/users/show.json"
    var params = Dictionary<String,String>()
    var user = Dictionary<String,Any>()
    let client = TWTRAPIClient()
    var clientError: NSError?
    
    var userPhoto = ""
    
    //MARK: View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if user.count > 0 {
            guard let userScreenName = user["screen_name"] as? String else {
                return
            }
            getUserProfile(screenName: userScreenName)

            guard let userName = user["name"] as? String else {
                return
            }
            self.dataSource = TWTRUserTimelineDataSource(screenName: userScreenName, apiClient: client)
            self.title = userName
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(userPhotoTapped(_:)))
        profileImageView.addGestureRecognizer(tap)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(userPhotoTapped(_:)))
        backgroundImageView.addGestureRecognizer(tap2)
    }

    //MARK: Custom Methods
    //Open picture in fullscreen when the user taps on it
    @objc func userPhotoTapped(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        var newImageView = UIImageView()
        if imageView == profileImageView {
            if imageView.image == #imageLiteral(resourceName: "default_profile") {
                newImageView = UIImageView(image: imageView.image)
            } else {
                newImageView.kf.setImage(with: URL(string: userPhoto))
            }
        } else {
            newImageView = UIImageView(image: imageView.image)
        }
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage(_:)))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    //Dismissing the presented picture
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //Requesting User profile from the API
    func getUserProfile( screenName: String) {
        params.updateValue(screenName, forKey: "screen_name")
        let request = client.urlRequest(withMethod: "GET", url: url, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) in
            if connectionError != nil {
                print("Error: \(connectionError?.localizedDescription ?? "hi")")
            } else {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data!, options: []) as? Dictionary<String,Any> else {
                        return
                    }
                    if let userImage = json["profile_image_url_https"] as? String  {
                        let newURL = userImage.replacingOccurrences(of: "_normal", with: "_bigger")
                        self.userPhoto = userImage.replacingOccurrences(of: "_normal", with: "")
                        self.profileImageView.kf.setImage(with: URL(string: newURL))
                    } else {
                        self.profileImageView.image = #imageLiteral(resourceName: "default_profile")
                    }
                    if let userBackgroundImage = json["profile_banner_url"] as? String {
                        self.backgroundImageView.kf.setImage(with: URL(string: userBackgroundImage))
                    } else {
                        self.backgroundImageView.image = #imageLiteral(resourceName: "default")
                    }
                } catch let jsonError as NSError {
                    print("Json error: \(jsonError.localizedDescription)")
                }
            }
            
        }
    }

}
