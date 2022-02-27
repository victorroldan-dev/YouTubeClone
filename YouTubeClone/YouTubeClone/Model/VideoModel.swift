//
//  VideoModel.swift
//  YouTubeClone
//
//  Created by Victor Roldan on 23/02/22.
//

import Foundation

// MARK: - VideoModel
struct VideoModel: Decodable {
    let kind, etag: String
    let items: [Item]
    let pageInfo: PageInfo
    
    
    // MARK: - PageInfo
    struct PageInfo: Codable {
        let totalResults, resultsPerPage: Int
    }
    
    // MARK: - Item
    struct Item: Decodable {
        let kind: String
        let id: String?
        let snippet: Snippet?
        let contentDetails: ContentDetails?
        let statistics: Statistics?
        
        
        enum CodingKeys: String, CodingKey {
            case kind
            case id
            case snippet
            case contentDetails
            case statistics
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.kind = try container.decode(String.self, forKey: .kind)
            
            if let id = try? container.decode(VideoId.self, forKey: .id){
                self.id = id.videoId
            }else{
                if let id = try? container.decode(String.self, forKey: .id){
                    self.id = id
                }else{
                    self.id = nil
                }
            }
            
            if let snippet = try? container.decode(Snippet.self, forKey: .snippet){
                self.snippet = snippet
            }else{
                self.snippet = nil
            }
            
            if let contentDetails = try? container.decode(ContentDetails.self, forKey: .contentDetails){
                self.contentDetails = contentDetails
            }else{
                self.contentDetails = nil
            }
            
            if let statistics = try? container.decode(Statistics.self, forKey: .statistics){
                self.statistics = statistics
            }else{
                self.statistics = nil
            }
            
            
            
        }
        
        
        
        
        struct VideoId: Decodable{
            let kind : String
            let videoId : String
        }
        
        // MARK: - Snippet
        struct Snippet: Codable {
            let publishedAt: String
            let channelId: String
            let title: String
            let description: String
            let thumbnails: Thumbnails
            let channelTitle: String
            let tags: [String]?

            
            enum CodingKeys: String, CodingKey {
                case publishedAt
                case channelId
                case title
                case description
                case thumbnails
                case channelTitle
                case tags
            }
            
            // MARK: - Thumbnails
            struct Thumbnails: Codable {
                let medium, high: Default
                
                enum CodingKeys: String, CodingKey {
                    case medium
                    case high
                }
                
                // MARK: - Default
                struct Default: Codable {
                    let url: String
                    let width, height: Int
                }//Default
                
            }
        }//Snippet
        
        // MARK: - ContentDetails
        struct ContentDetails: Codable {
            let duration, dimension, definition, caption: String
            let licensedContent: Bool
            let projection: String
        }
        
        
        // MARK: - Statistics
        struct Statistics: Codable {
            let viewCount, likeCount, favoriteCount, commentCount: String
        }
    }
}








