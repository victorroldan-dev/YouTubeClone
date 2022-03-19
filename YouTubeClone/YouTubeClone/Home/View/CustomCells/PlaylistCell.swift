//
//  PlaylistCell.swift
//  YouTubeClone
//
//  Created by Victor Roldan on 6/03/22.
//

import UIKit
import Kingfisher

class PlaylistCell: UITableViewCell {

    @IBOutlet weak var dotsImage: UIImageView!
    @IBOutlet weak var videoCountOverlay: UILabel!
    @IBOutlet weak var videoCount: UILabel!
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var videoImage: UIImageView!
    var didTapDostsButton : (()->Void)?
    
    override func awakeFromNib() {
        configView()
    }
    
    @IBAction func dotsButtonTapped(_ sender: Any) {
        if let tap = didTapDostsButton{
            tap()
        }
    }
    
    private func configView(){
        selectionStyle = .none
        super.awakeFromNib()
        dotsImage.image = .dotsImage
        dotsImage.tintColor = .whiteColor
    }
    
    func configCell(model : PlaylistModel.Item){
        videoTitle.text = model.snippet.title
        videoCount.text = String(model.contentDetails.itemCount)+" videos"
        videoCountOverlay.text = String(model.contentDetails.itemCount)
        
        let imageUrl = model.snippet.thumbnails.medium.url
        if let url = URL(string: imageUrl){
            videoImage.kf.setImage(with: url)
        }
    }

}
