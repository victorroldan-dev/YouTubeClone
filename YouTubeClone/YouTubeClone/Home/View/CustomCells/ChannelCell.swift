//
//  ChannelCell.swift
//  YouTubeClone
//
//  Created by Victor Roldan on 6/03/22.
//

import UIKit
import Kingfisher

class ChannelCell: UITableViewCell {
    @IBOutlet weak var bannerImage: UIImageView!
    
    @IBOutlet weak var channelInfoLabel: UILabel!
    @IBOutlet weak var subscriberNumbersLabel: UILabel!
    @IBOutlet weak var bellImage: UIImageView!
    @IBOutlet weak var subscribeLabel: UILabel!
    @IBOutlet weak var channelTitle: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }
    
    private func configView(){
        bellImage.image = UIImage(named: "bell")?.withRenderingMode(.alwaysTemplate)
        bellImage.tintColor = UIColor(named: "grayColor")
        profileImage.layer.cornerRadius = 51/2
    }

    func configCell(model : ChannelModel.Items){
        channelInfoLabel.text = model.snippet.description
        channelTitle.text = model.snippet.title
        subscriberNumbersLabel.text = "\(model.statistics?.subscriberCount ?? "0") subscribers · \(model.statistics?.videoCount ?? "0") videos"
        
        if let bannerUrl = model.brandingSettings?.image.bannerExternalUrl, let url = URL(string: bannerUrl){
            bannerImage.kf.setImage(with: url)
        }
        
        let imageUrl = model.snippet.thumbnails.medium.url
        
        guard let url = URL(string: imageUrl) else{
            return
        }
        profileImage.kf.setImage(with: url)
        
    }
    
}
