//
//  HomeViewController.swift
//  YouTubeClone
//
//  Created by Victor Roldan on 23/02/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableViewHome: UITableView!
    lazy var presenter = HomePresenter(delegate: self)
    private var objectList : [[Any]] = []
    private var sectionTitleList : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        
        Task{
            await presenter.getHomeObjects()
        }
    }
    
    func configTableView(){
        let nibChannel = UINib(nibName: "\(ChannelCell.self)", bundle: nil)
        tableViewHome.register(nibChannel, forCellReuseIdentifier: "\(ChannelCell.self)")
        
        let nibVideo = UINib(nibName: "\(VideoCell.self)", bundle: nil)
        tableViewHome.register(nibVideo, forCellReuseIdentifier: "\(VideoCell.self)")
        
        let nibPlaylist = UINib(nibName: "\(PlaylistCell.self)", bundle: nil)
        tableViewHome.register(nibPlaylist, forCellReuseIdentifier: "\(PlaylistCell.self)")
        
        tableViewHome.register(SectionTitleView.self, forHeaderFooterViewReuseIdentifier: "\(SectionTitleView.self)")
        
        tableViewHome.delegate = self
        tableViewHome.dataSource = self
        tableViewHome.separatorColor = .clear
    }
}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectList[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return objectList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = objectList[indexPath.section]
        if let channel = item as? [ChannelModel.Items]{
            guard let channelCell = tableView.dequeueReusableCell(withIdentifier: "\(ChannelCell.self)", for: indexPath) as? ChannelCell else{
                return UITableViewCell()
            }
            channelCell.configCell(model: channel[indexPath.row])
            return channelCell
        }else if let playlistItems = item as? [PlaylistItemsModel.Item]{
            guard let playlistItemsCell = tableView.dequeueReusableCell(withIdentifier: "\(VideoCell.self)", for: indexPath) as? VideoCell else{
                return UITableViewCell()
            }
            playlistItemsCell.configCell(model: playlistItems[indexPath.row])
            return playlistItemsCell
        }else if let videos = item as? [VideoModel.Item]{
            guard let videoCell = tableView.dequeueReusableCell(withIdentifier: "\(VideoCell.self)", for: indexPath) as? VideoCell else{
                return UITableViewCell()
            }
            videoCell.configCell(model: videos[indexPath.row])
            return videoCell
            
        }else if let playlist = item as? [PlaylistModel.Item]{
            guard let playlistCell = tableView.dequeueReusableCell(withIdentifier: "\(PlaylistCell.self)", for: indexPath) as? PlaylistCell else{
                return UITableViewCell()
            }
            playlistCell.configCell(model: playlist[indexPath.row])
            return playlistCell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 || indexPath.section == 2{
            return 95.0
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "\(SectionTitleView.self)") as? SectionTitleView else{
            return nil
        }
        sectionView.title.text = sectionTitleList[section]
        sectionView.configView()
        return sectionView
    }
}


extension HomeViewController : HomeViewProtocol{
    func getData(list: [[Any]], sectionTitleList: [String]) {
        objectList = list
        self.sectionTitleList = sectionTitleList
        tableViewHome.reloadData()
    }
}
