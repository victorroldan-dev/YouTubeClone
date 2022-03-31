//
//  VideoFullWidthCell.swift
//  YouTubeClone
//
//  Created by Victor Roldan on 28/03/22.
//

import UIKit

class VideoFullWidthCell: UITableViewCell {

    @IBOutlet weak var videoImage: UIImageView!
        @IBOutlet weak var videoTitle: UILabel!
        @IBOutlet weak var statistics: UILabel!
        
        override func awakeFromNib() {
            super.awakeFromNib()
        }

        func configCell(model : VideoModel.Item){
            videoTitle.text = model.snippet?.title
            videoTitle.textColor = .whiteColor
            
            let channelTitle = model.snippet?.channelTitle ?? ""
            //let pusblished = model.snippet?.publishedDateFriendly ?? ""
            let randInt = Int.random(in: 200..<999)
            statistics.text = "\(channelTitle) · \(randInt) views · 3 days ago"
            statistics.textColor = .grayColor
            
            guard let imageUrl = model.snippet?.thumbnails.medium?.url, let url = URL(string: imageUrl) else{
                videoImage.image = .videoPlaceholder
                return
            }
            videoImage.kf.setImage(with: url, placeholder: UIImage.videoPlaceholder)
        }
        
}
