//
//  PlayVideoViewController.swift
//  YouTubeClone
//
//  Created by Victor Roldan on 25/03/22.
//

import UIKit
import youtube_ios_player_helper

class PlayVideoViewController: BaseViewController {
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var tableViewVideos: UITableView!
    lazy var presenter = PlayVideoPresenter(delegate: self)
    var goingToBeCollapsed : ((Bool)->Void)?
    
    var videoId : String = ""
    lazy var collapseVideoButton : UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("", for: .normal)
        button.setImage(UIImage.chevronDown, for: .normal)
        button.tintColor = .whiteColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(collapsedVideoButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        configPlayerView()
        loadDataFromApi()
        configCloseButton()
    }
    
    private func loadDataFromApi(){
        Task{ [weak self] in
            await self?.presenter.getVideos(videoId)
        }
    }
    
    func configPlayerView(){
        let playerVars : [AnyHashable : Any] = ["playsinline":1, "controls":1, "autohide": 1, "showinfo": 0, "modestbranding":0]
        
        playerView.load(withVideoId: videoId, playerVars: playerVars)
        playerView.delegate = self
    }
    
    private func configTableView(){
        //Delegates
        tableViewVideos.delegate = self
        tableViewVideos.dataSource = self
        
        //Register TableView
        tableViewVideos.register(cell: VideoHeaderCell.self)
        tableViewVideos.register(cell: VideoFullWidthCell.self)
        
        tableViewVideos.rowHeight = UITableView.automaticDimension
        tableViewVideos.estimatedRowHeight = 60
    }
    
    private func configCloseButton(){
        playerView.addSubview(collapseVideoButton)
        NSLayoutConstraint.activate([
            collapseVideoButton.topAnchor.constraint(equalTo: playerView.topAnchor, constant: 5),
            collapseVideoButton.leadingAnchor.constraint(equalTo: playerView.leadingAnchor, constant: 5),
            collapseVideoButton.widthAnchor.constraint(equalToConstant: 25),
            collapseVideoButton.heightAnchor.constraint(equalToConstant: 25),
        ])
    }
    
    @objc private func collapsedVideoButtonPressed(_ sender : UIButton){
        guard let goingToBeCollapsed = self.goingToBeCollapsed else {return}
        goingToBeCollapsed(true)
    }

    
}
extension PlayVideoViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.relatedVideoList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.relatedVideoList[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = presenter.relatedVideoList[indexPath.section]
        if indexPath.section == 0{
            guard let video = item[indexPath.row] as? VideoModel.Item else{ return UITableViewCell()}
            
            let videoHeaderCell = tableView.dequeueReusableCell(for: VideoHeaderCell.self, for: indexPath)
            videoHeaderCell.configCell(videoModel: video, channelModel: presenter.channelModel)
            videoHeaderCell.selectionStyle = .none
            return videoHeaderCell
            
        }else{
            
            guard let video = item[indexPath.row] as? VideoModel.Item else{ return UITableViewCell()}
            let videoFullWidthCell = tableView.dequeueReusableCell(for: VideoFullWidthCell.self, for: indexPath)
            videoFullWidthCell.configCell(model: video)
            return videoFullWidthCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 270
        }else{
            return 290
        }
    }
}

extension PlayVideoViewController : YTPlayerViewDelegate{
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
}

extension PlayVideoViewController : PlayVideoViewProtocol{
    func getRelatedVideosFinished() {
        print("response")
        tableViewVideos.reloadData()
    }
}
