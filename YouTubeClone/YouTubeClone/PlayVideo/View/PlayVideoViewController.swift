//
//  PlayVideoViewController.swift
//  YouTubeClone
//
//  Created by Victor Roldan on 25/03/22.
//

import UIKit
import youtube_ios_player_helper

class PlayVideoViewController: UIViewController {
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var tableViewVideos: UITableView!
    
    var videoId : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configPlayerView()
    }
    
    func configPlayerView(){
        let playerVars : [AnyHashable : Any] = ["playsinline":1, "controls":1, "autohide": 1, "showinfo": 0, "modestbranding":0]
                
        playerView.load(withVideoId: videoId, playerVars: playerVars)
        playerView.delegate = self
    }

}

extension PlayVideoViewController : YTPlayerViewDelegate{
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
}
