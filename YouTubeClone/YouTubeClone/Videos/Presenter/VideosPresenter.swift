//
//  VideoPresenter.swift
//  YouTubeClone
//
//  Created by Victor Roldan on 17/03/22.
//

import Foundation

protocol VideosViewProtocol : AnyObject{
    func getVideos(videoList : [VideoModel.Item])
}



class VideosPresenter{
    private weak var delegate : VideosViewProtocol?
    private var provider : VideoProviderProtocol
    
    init(delegate : VideosViewProtocol, provider : VideoProviderProtocol = VideosProvider()){
        self.provider = provider
        self.delegate = delegate
        
        #if DEBUG
        if MockManager.shared.runAppWithMock{
            self.provider = VideosProviderMock()
        }
        #endif
    }
    
    @MainActor
    func getVideos() async{
        do{
            let videos = try await provider.getVideos(channelId: Constants.channelId).items
            delegate?.getVideos(videoList: videos)
        }catch{
            debugPrint(error.localizedDescription)
        }
        
    }
}
