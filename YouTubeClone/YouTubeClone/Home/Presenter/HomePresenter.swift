//
//  HomePresenter.swift
//  YouTubeClone
//
//  Created by Victor Roldan on 27/02/22.
//

import Foundation

protocol HomeViewProtocol: AnyObject{
    func getData(list : [[Any]])
}

class HomePresenter{
    var provider : HomeProviderProtocol
    weak var delegate : HomeViewProtocol?
    private var objectList : [[Any]] = []
    
    init(delegate : HomeViewProtocol, provider : HomeProviderProtocol = HomeProvider()){
        self.provider = provider
        self.delegate = delegate
    }
    
    @MainActor
    func getHomeObjects() async{
        objectList.removeAll()

        async let channel = try await provider.getChannel(channelId: Constants.channelId).items
        async let playlist = try await provider.getPlaylists(channelId: Constants.channelId).items
        async let videos = try await provider.getVideos(searchString: "", channelId: Constants.channelId).items
        

        do{
            let (responseChannel, responsePlaylist, responseVideos) = await (try channel, try playlist, try videos)
            
            //Index 0
            objectList.append(responseChannel)
            
            if let playlistId = responsePlaylist.first?.id, let playlistItems = await getPlaylistItems(playlistId: playlistId){
                //Index 1
                objectList.append(playlistItems.items)
            }
            //Index 2
            objectList.append(responseVideos)
            
            //Index 3
            objectList.append(responsePlaylist)
            
            delegate?.getData(list: objectList)
            
        }catch{
            print(error)
        }
        
        
    }
    
    func getPlaylistItems(playlistId: String) async -> PlaylistItemsModel?{
        do{
            let playlistItems = try await provider.getPlaylistItems(playlistId: playlistId)
            return playlistItems
        }catch{
            print("error:", error)
            return nil
        }
        
        
    }
    
}
