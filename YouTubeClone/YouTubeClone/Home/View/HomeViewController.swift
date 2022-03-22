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
        tableViewHome.register(cell: ChannelCell.self)
        tableViewHome.register(cell: VideoCell.self)
        tableViewHome.register(cell: PlaylistCell.self)
        tableViewHome.registerFromClass(headerFooterView: SectionTitleView.self)
        
        tableViewHome.delegate = self
        tableViewHome.dataSource = self
        tableViewHome.separatorColor = .clear
        tableViewHome.contentInset = UIEdgeInsets(top: -15, left: 0, bottom: -80, right: 0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pan = scrollView.panGestureRecognizer
        let velocity = pan.velocity(in: scrollView).y
        if velocity < -5 {
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else if velocity > 5 {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
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
            let channelCell = tableView.dequeueReusableCell(for: ChannelCell.self, for: indexPath)
            channelCell.configCell(model: channel[indexPath.row])
            return channelCell
            
        }else if let playlistItems = item as? [PlaylistItemsModel.Item]{
            let playlistItemsCell = tableView.dequeueReusableCell(for: VideoCell.self, for: indexPath)
            playlistItemsCell.configCell(model: playlistItems[indexPath.row])
            playlistItemsCell.didTapDostsButton = {[weak self] in
                self?.configButtonSheet()
            }
            return playlistItemsCell
            
        }else if let videos = item as? [VideoModel.Item]{
            let videoCell = tableView.dequeueReusableCell(for: VideoCell.self, for: indexPath)
            videoCell.didTapDostsButton = {[weak self] in
                self?.configButtonSheet()
            }
            videoCell.configCell(model: videos[indexPath.row])
            return videoCell
            
        }else if let playlist = item as? [PlaylistModel.Item]{
            let playlistCell = tableView.dequeueReusableCell(for: PlaylistCell.self, for: indexPath)
            playlistCell.configCell(model: playlist[indexPath.row])
            playlistCell.didTapDostsButton = {[weak self] in
                self?.configButtonSheet()
            }
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
    
    
    func configButtonSheet(){
        let vc = BottomSheetViewController()
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
}


extension HomeViewController : HomeViewProtocol{
    func getData(list: [[Any]], sectionTitleList: [String]) {
        objectList = list
        self.sectionTitleList = sectionTitleList
        tableViewHome.reloadData()
    }
}
