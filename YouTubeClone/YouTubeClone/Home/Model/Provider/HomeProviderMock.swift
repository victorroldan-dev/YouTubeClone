//
//  HomeProviderMock.swift
//  YouTubeClone
//
//  Created by Victor Roldan on 4/03/22.
//

import Foundation

class HomeProviderMock : HomeProviderProtocol{
    func getVideos(searchString: String, channelId: String) async throws -> VideoModel {
        guard let model = Utils.parseJson(jsonName: "SearchVideos", model: VideoModel.self) else{
            throw NetworkError.jsonDecoder
        }
        return model
    }
    
    func getChannel(channelId: String) async throws -> ChannelModel {
        guard let model = Utils.parseJson(jsonName: "Channel", model: ChannelModel.self) else{
            throw NetworkError.jsonDecoder
        }
        return model
    }
    
    func getPlaylists(channelId: String) async throws -> PlaylistModel {
        guard let model = Utils.parseJson(jsonName: "Playlists", model: PlaylistModel.self) else{
            throw NetworkError.jsonDecoder
        }
        return model
    }
    
    func getPlaylistItems(playlistId: String) async throws -> PlaylistItemsModel {
        guard let model = Utils.parseJson(jsonName: "PlaylistItems", model: PlaylistItemsModel.self) else{
            throw NetworkError.jsonDecoder
        }
        return model
    }
    
    
}
