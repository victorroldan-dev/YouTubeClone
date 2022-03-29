//
//  VideoHeaderCell.swift
//  YouTubeClone
//
//  Created by Victor Roldan on 28/03/22.
//

import UIKit

class VideoHeaderCell: UITableViewCell {
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var videoStatistics: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var channelName: UILabel!
    @IBOutlet weak var subscriberCount: UILabel!
    @IBOutlet weak var subscribeLabel: UILabel!
    @IBOutlet weak var bellIcon: UIImageView!
    @IBOutlet weak var buttonsIconListView: ButtonsIconList!
    @IBOutlet weak var commentTitle: UILabel!
    @IBOutlet weak var commentProfileImage: UIImageView!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var seeAllCommentButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configHorizontalButtons(_ videoModel : VideoModel.Item){
        let options = [
            VideoButtonIcon(title: videoModel.statistics?.likeCount ?? "-", icon: .like),
            VideoButtonIcon(title: "Dislike", icon: .dislike),
            VideoButtonIcon(title: "Share", icon: .share),
            VideoButtonIcon(title: "Download", icon: .download),
            VideoButtonIcon(title: "Save", icon: .save),
            VideoButtonIcon(title: "Airplay", icon: .airplay),
        ]
        buttonsIconListView.buttonIconsList = options
        buttonsIconListView.delegate = self
        buttonsIconListView.buildView()
    }
    
    func configCell(videoModel : VideoModel.Item, channelModel : ChannelModel.Items?){
        configHorizontalButtons(videoModel)
        
        commentConfig()
        
        videoTitle.text = videoModel.snippet?.title
        videoTitle.textColor = .whiteColor
        
        let viewCount = videoModel.statistics?.viewCount ?? "0"
        let viewPlural = (Int(viewCount)!) > 0 ? "views" : "view"
        var tags = ""
        if let tagsArray = videoModel.snippet?.tags?.enumerated().filter({$0.offset<3}).map({"#"+$0.element}){
            tags = tagsArray.joined(separator: " ")
        }
        let published = "2 weeks ago"//videoModel.snippet?.publishedDateFriendly ?? ""
        let wholeString = "\(viewCount) \(viewPlural) · \(published) \(tags)"
        
        videoStatistics.text = wholeString
        videoStatistics.textColor = .grayColor
        videoStatistics.highlight(searchedText: tags, color: .systemBlue)
        
        channelDetails(videoModel, channelModel)
    }
    
    private func channelDetails(_ videoModel : VideoModel.Item, _ channelModel : ChannelModel.Items?){
        channelName.text = videoModel.snippet?.channelTitle
        channelName.textColor = .whiteColor
        
        subscribeLabel.text = "SUBSCRIBED"
        subscribeLabel.textColor = .grayColor
        
        bellIcon.image = .bellImage
        bellIcon.tintColor = .grayColor
        
        subscriberCount.text = "\(channelModel?.statistics?.subscriberCount ?? "") subscribers"
        subscriberCount.textColor = .grayColor
        
        guard let imageUrl = channelModel?.snippet.thumbnails.medium.url, let url = URL(string: imageUrl) else{ return }
        profileImage.kf.setImage(with: url)
        profileImage.layer.cornerRadius = 20.0
    }
    
    private func commentConfig(){
        let randomInt = Int.random(in: 100..<1000)
        commentTitle.text = "Comments \(randomInt)"
        commentProfileImage.image = UIImage.personCircleFill
        commentProfileImage.tintColor = .whiteColor
        comment.text = "Excelente información. Gracias."
    }
}

extension VideoHeaderCell : ButtonIconListProtocol{
    func didSelectOption(tag: Int) {
        print("tag selected: \(tag)")
    }
}
