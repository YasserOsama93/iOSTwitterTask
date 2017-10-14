//
//  FollowerTableViewCell.swift
//  iOSTaskTwitter
//
//  Created by Yasser Osama on 10/14/17.
//  Copyright © 2017 Yasser Osama. All rights reserved.
//

import UIKit

class FollowerTableViewCell: UITableViewCell {

    @IBOutlet weak var followerImageView: UIImageView!
    @IBOutlet weak var followerName: UILabel!
    @IBOutlet weak var followerScreenName: UILabel!
    @IBOutlet weak var followerBio: UILabel!
    
    var user = Dictionary<String,Any>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
