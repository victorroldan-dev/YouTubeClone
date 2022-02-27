//
//  HomeProvider.swift
//  YouTubeClone
//
//  Created by Victor Roldan on 27/02/22.
//

import Foundation

protocol HomeProviderProtocol{
    func getVideos(searchString : String, channelId : String) async throws -> VideoModel
    func getChannel(channelId : String) async throws -> ChannelModel
    func getPlaylists(channelId : String) async throws -> PlaylistModel
    func getPlaylistItems(playlistId : String) async throws -> PlaylistItemsModel
}


class HomeProvider : HomeProviderProtocol{
    func getVideos(searchString : String, channelId : String) async throws -> VideoModel{
        var queryParams : [String:String] = ["part":"snippet", "type": "video"]
        if !channelId.isEmpty{
            queryParams["channelId"] = channelId
        }
        if !searchString.isEmpty{
            queryParams["q"] = searchString
        }
        let requestModel = RequestModel(endpoint: .search, queryItems: queryParams)
        
        do{
            let model = try await ServiceLayer.callService(requestModel, VideoModel.self)
            return model
        }catch{
            print(error)
            throw error
        }
    }
    
    func getChannel(channelId : String) async throws -> ChannelModel{
        let queryParams : [String:String] = ["part":"snippet,statistics,brandingSettings",
                                             "id":channelId]

        let requestModel = RequestModel(endpoint: .channels, queryItems: queryParams)
        
        do{
            let model = try await ServiceLayer.callService(requestModel, ChannelModel.self)
            return model
        }catch{
            print(error)
            throw error
        }
    }
    
    func getPlaylists(channelId : String) async throws -> PlaylistModel{
        let queryParams : [String:String] = ["part":"snippet,contentDetails",
                                             "channelId":channelId]

        let requestModel = RequestModel(endpoint: .playlist, queryItems: queryParams)
        
        do{
            let model = try await ServiceLayer.callService(requestModel, PlaylistModel.self)
            return model
        }catch{
            print(error)
            throw error
        }
    }
    
    func getPlaylistItems(playlistId : String) async throws -> PlaylistItemsModel{
        let queryParams : [String:String] = ["part":"snippet,id,contentDetails",
                                             "playlistId":playlistId]

        let requestModel = RequestModel(endpoint: .playlistItems, queryItems: queryParams)
        
        do{
            let model = try await ServiceLayer.callService(requestModel, PlaylistItemsModel.self)
            return model
        }catch{
            print(error)
            throw error
        }
    }
    
    
}
