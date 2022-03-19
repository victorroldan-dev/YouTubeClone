//
//  VideoCell.swift
//  YouTubeClone
//
//  Created by Victor Roldan on 6/03/22.
//

import UIKit

class VideoCell: UITableViewCell {

    @IBOutlet weak var dotsImage: UIImageView!
    @IBOutlet weak var viewsCountLabel: UILabel!
    @IBOutlet weak var channelName: UILabel!
    @IBOutlet weak var videoName: UILabel!
    @IBOutlet weak var videoImage: UIImageView!
    
    var didTapDostsButton : (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }

    private func configView(){
        selectionStyle = .none
    }
    
    @IBAction func dotsButtonTapped(_ sender: Any) {
        if let tap = didTapDostsButton{
            tap()
        }
    }
    func configCell(model : Any){
        dotsImage.image = .dotsImage
        dotsImage.tintColor = .whiteColor
        
        if let video = model as? VideoModel.Item{
            if let imageUrl = video.snippet?.thumbnails.medium?.url, let url = URL(string: imageUrl){
                videoImage.kf.setImage(with: url)
            }
            videoName.text = video.snippet?.title ?? ""
            channelName.text = video.snippet?.channelTitle ?? ""
            
            viewsCountLabel.text = "\(video.statistics?.viewCount ?? "0") views · 3 months ago"
            
            
            
        }else if let playlistItems = model as? PlaylistItemsModel.Item { // Playlist Items
            if let imageUrl = playlistItems.snippet.thumbnails.medium?.url, let url = URL(string: imageUrl){
                videoImage.kf.setImage(with: url)
            }
            videoName.text = playlistItems.snippet.title
            channelName.text = playlistItems.snippet.channelTitle
            
            viewsCountLabel.text = "332 views · 3 months ago"
            
            
        }
        
    }
    
    
}
