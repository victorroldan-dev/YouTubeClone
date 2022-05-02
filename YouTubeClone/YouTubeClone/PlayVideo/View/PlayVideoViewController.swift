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
    
    @IBOutlet weak var tipView: UIView!
    @IBOutlet weak var xmarkCloseVideo: UIButton!
    @IBOutlet weak var playVideoButton: UIButton!
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var channelTitleLabel: UILabel!
    @IBOutlet weak var playerViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var playerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var safeAreaInsetView: UIView!
    
    lazy var presenter = PlayVideoPresenter(delegate: self)
    var goingToBeCollapsed : ((Bool)->Void)?
    var isClosedVideo : (()->Void)?
    var videoId : String = ""
    
    var isPlayingVideo : Bool = false{
        didSet{
            playVideoButton.setImage(isPlayingVideo ? .pause : .playFill, for: .normal)
        }
    }
    
    lazy var collapseVideoButton : UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("", for: .normal)
        button.setImage(UIImage.chevronDown, for: .normal)
        button.tintColor = .whiteColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(collapsedVideoButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    var topInsetSafeArea : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    var progressBar : UIProgressView = {
        let progress = UIProgressView()
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.trackTintColor = .clear
        progress.progressTintColor = .red
        progress.progress = 0.0
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        configPlayerView()
        loadDataFromApi()
        configCloseButton()
        generalConfigs()
        configTopInsetSafeAreaConstraints()
        configProgressLayout()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .viewPosition, object: nil)
    }
    
    private func generalConfigs(){
        NotificationCenter.default.addObserver(self, selector: #selector(floatingPannelChanged(notification:)), name: .viewPosition, object: nil)
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
    
    func configTopInsetSafeAreaConstraints(){
        view.addSubview(topInsetSafeArea)
        NSLayoutConstraint.activate([
            topInsetSafeArea.widthAnchor.constraint(equalTo: view.widthAnchor),
            topInsetSafeArea.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topInsetSafeArea.topAnchor.constraint(equalTo: view.topAnchor),
            topInsetSafeArea.bottomAnchor.constraint(equalTo: playerView.topAnchor),
        ])
    }
    
    func configProgressLayout() {
        tipView.addSubview(progressBar)
        NSLayoutConstraint.activate([
            progressBar.widthAnchor.constraint(equalTo: tipView.widthAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 2.0),
            progressBar.centerXAnchor.constraint(equalTo: tipView.centerXAnchor),
            progressBar.bottomAnchor.constraint(equalTo: tipView.bottomAnchor, constant: 12),
        ])
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

    @objc func floatingPannelChanged(notification: Notification){
        guard let value = notification.object as? [String : String] else{return}
        if value["position"] == "top"{
            tipView.isHidden = true
            playerViewHeightConstraint.constant = 225.0
            playerViewTrailingConstraint.constant = 0.0
            collapseVideoButton.isHidden = false
            view.layoutIfNeeded()
            safeAreaInsetView.isHidden = true
        }else{//bottom
            tipView.isHidden = false
            collapseVideoButton.isHidden = true
            playerViewHeightConstraint.constant = playerViewHeightConstraint.constant*0.3
            playerViewTrailingConstraint.constant = UIScreen.main.bounds.width*0.7
            view.layoutIfNeeded()
            safeAreaInsetView.isHidden = false
        }
    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
        isPlayingVideo ? playerView.stopVideo() : playerView.playVideo()
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        if let isClosedVideo = isClosedVideo{
            isClosedVideo()
        }
        dismiss(animated: true)
    }
    
    @IBAction func tipViewButtonPressed(_ sender: Any) {
        if let goingToBeCollapsed = goingToBeCollapsed {
            goingToBeCollapsed(false)
        }
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
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        switch state {
        case .unstarted:
            print("unstarted")
        case .ended:
            print("ended")
            isPlayingVideo = false
        case .playing:
            print("playing")
            isPlayingVideo = true
        case .paused:
            print("paused")
            isPlayingVideo = false
        case .buffering:
            print("buffering")
        case .cued:
            isPlayingVideo = false
            print("cued")
        case .unknown:
            print("unknown")
        @unknown default:
            print("error")
        }
    }
    
    func playerView(_ playerView: YTPlayerView, didPlayTime playTime: Float) {
        playerView.duration { duration, error in
            self.progressBar.progress = (playTime/Float(duration))
        }
    }
}

extension PlayVideoViewController : PlayVideoViewProtocol{
    func getRelatedVideosFinished() {
        if let video = presenter.relatedVideoList[0].first as? VideoModel.Item,
           let title = video.snippet?.title{
            videoTitleLabel.text = title
        }
        channelTitleLabel.text = presenter.channelModel?.snippet.title
        tableViewVideos.reloadData()
    }
}
