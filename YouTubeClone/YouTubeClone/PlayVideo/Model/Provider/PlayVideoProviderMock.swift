//
//  PlayVideoProviderMock.swift
//  YouTubeClone
//
//  Created by Victor Roldan on 27/03/22.
//

import Foundation

class PlayVideoProviderMock : PlayVideoProviderProtocol{
    func getVideo(_ videoId : String) async throws -> VideoModel{
        guard let model = Utils.parseJson(jsonName: "VideoOnlyOne", model: VideoModel.self) else{
            throw NetworkError.jsonDecoder
        }
        return model
    }
    
    func getRelatedVideos(_ relatedToVideoId : String) async throws -> VideoModel{
        guard let model = Utils.parseJson(jsonName: "SearchVideos", model: VideoModel.self) else{
            throw NetworkError.jsonDecoder
        }
        return model
        
    }
    
    func getChannel(_ channelId : String) async throws -> ChannelModel{
        guard let model = Utils.parseJson(jsonName: "Channel", model: ChannelModel.self) else{
            throw NetworkError.jsonDecoder
        }
        return model
    }
    
}
