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
    struct Item: Codable {
        let kind, etag, id: String
        let snippet: Snippet
        let contentDetails: ContentDetails
        let status: Status
        let statistics: Statistics
        let topicDetails: TopicDetails
        
        // MARK: - Snippet
        struct Snippet: Codable {
            let publishedAt: Date
            let channelId, title, description: String
            let thumbnails: Thumbnails
            let channelTitle: String
            let tags: [String]
            let categoryId, liveBroadcastContent: String
            let localized: Localized
            let defaultAudioLanguage: String
            
            enum CodingKeys: String, CodingKey {
                case publishedAt
                case channelId
                case title
                case description
                case thumbnails, channelTitle, tags
                case categoryId
                case liveBroadcastContent, localized, defaultAudioLanguage
            }
            
            // MARK: - Localized
            struct Localized: Codable {
                let title, description: String
                
                enum CodingKeys: String, CodingKey {
                    case title
                    case description
                }
            }
            
            
            // MARK: - Thumbnails
            struct Thumbnails: Codable {
                let thumbnailsDefault, medium, high: Default
                
                enum CodingKeys: String, CodingKey {
                    case thumbnailsDefault = "default"
                    case medium, high
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
        
        // MARK: - Status
        struct Status: Codable {
            let uploadStatus, privacyStatus, license: String
            let embeddable, publicStatsViewable, madeForKids: Bool
        }
        
        // MARK: - TopicDetails
        struct TopicDetails: Codable {
            let topicCategories: [String]
        }
    }
}








