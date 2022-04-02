//
//  HomeViewController.swift
//  YouTubeClone
//
//  Created by Victor Roldan on 23/02/22.
//

import UIKit
import FloatingPanel

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var tableViewHome: UITableView!
    lazy var presenter = HomePresenter(delegate: self)
    private var objectList : [[Any]] = []
    private var sectionTitleList : [String] = []
    var fpc: FloatingPanelController?
    var floatingPanelIsPresented : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        configFloatinPanel()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = objectList[indexPath.section]
        var videoId : String = ""
        
        if let playlistItem = item as? [PlaylistItemsModel.Item]{
            videoId = playlistItem[indexPath.row].contentDetails?.videoId ?? ""
            
        }else if let videos = item as? [VideoModel.Item]{
            videoId = videos[indexPath.row].id ?? ""
        }
        if floatingPanelIsPresented{
            fpc?.willMove(toParent: nil)
            fpc?.hide(animated: true, completion: {[weak self] in
                guard let self = self else {return}
                // Remove the floating panel view from your controller's view.
                self.fpc?.view.removeFromSuperview()
                // Remove the floating panel controller from the controller hierarchy.
                self.fpc?.removeFromParent()
                
                self.dismiss(animated: true, completion: {
                    self.presentViewPanel(videoId)
                })
            })
        }else{
            presentViewPanel(videoId)
        }
        
        
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

extension HomeViewController : FloatingPanelControllerDelegate{
    func presentViewPanel(_ videoId : String){
        let contentVC = PlayVideoViewController()
        contentVC.videoId = videoId
        
        contentVC.goingToBeCollapsed = {[weak self] goingToBeCollapsed in
            guard let self = self else {return}
            if goingToBeCollapsed{
                self.fpc?.move(to: .tip, animated: true)
            }else{
                self.fpc?.move(to: .full, animated: true)
            }
        }
        
        fpc?.set(contentViewController: contentVC)
        fpc?.track(scrollView: contentVC.tableViewVideos)
        if let fpc = fpc{
            floatingPanelIsPresented = true
            present(fpc, animated: true)
        }
        
    }
    func configFloatinPanel(){
        fpc = FloatingPanelController(delegate: self)
        fpc?.isRemovalInteractionEnabled = true
        fpc?.surfaceView.grabberHandle.isHidden = true
        fpc?.layout = MyFloatingPanelLayout()
        fpc?.surfaceView.contentPadding = .init(top: -48, left: 0, bottom: -48, right: 0)
    }
    
    func floatingPanelDidRemove(_ fpc: FloatingPanelController) {
        //TODO:
    }
    
    func floatingPanelWillEndDragging(_ vc: FloatingPanelController, withVelocity velocity: CGPoint, targetState: UnsafeMutablePointer<FloatingPanelState>) {
        if targetState.pointee != .full {
            //TODO:
        }else{
            //TODO:
        }
    }

    
}

class MyFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .full
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelLayoutAnchor(absoluteInset: 0.0, edge: .top, referenceGuide: .safeArea),
            .tip: FloatingPanelLayoutAnchor(absoluteInset: 60.0, edge: .bottom, referenceGuide: .safeArea),
        ]
    }
}
