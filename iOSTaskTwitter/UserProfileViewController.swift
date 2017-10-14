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

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var user = Dictionary<String,Any>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if user.count > 0 {
            guard let userScreenName = user["screen_name"] as? String else {
                return
            }
            guard let profileImageUrl = user["profile_image_url_https"] as? String else {
                return
            }
            if let backgroundImageUrl = user["profile_banner_url"] as? String {
                backgroundImageView.kf.setImage(with: URL(string: backgroundImageUrl))
            } else {
                backgroundImageView.image = #imageLiteral(resourceName: "default")
            }
            guard let userName = user["name"] as? String else {
                return
            }
            let client = TWTRAPIClient()
            profileImageView.kf.setImage(with: URL(string: profileImageUrl))
            self.dataSource = TWTRUserTimelineDataSource(screenName: userScreenName, apiClient: client)
            self.title = userName
        }
        
        
    }


}
