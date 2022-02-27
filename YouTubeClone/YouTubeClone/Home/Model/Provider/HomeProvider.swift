//
//  HomeProvider.swift
//  YouTubeClone
//
//  Created by Victor Roldan on 27/02/22.
//

import Foundation


class HomeProvider{
    func getVideos(searchString : String, channelId : String) async throws -> VideoModel{
        var queryParams : [String:String] = ["part":"snippet"]
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
}
