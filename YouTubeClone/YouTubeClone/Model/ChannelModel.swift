//
//  ChannelModel.swift
//  YouTubeClone
//
//  Created by Victor Roldan on 23/02/22.
//

import Foundation

// MARK: - ChannelModel
struct ChannelModel: Codable {
    let kind: String
    let etag: String
    let pageInfo: PageInfo
    let items: [Items]
    
    // MARK: - PageInfo
    struct PageInfo: Codable {
        let totalResults: Int
        let resultsPerPage: Int
    }
    
    // MARK: - Items
    struct Items: Codable {
        let kind: String
        let etag: String
        let id: String
        let snippet: Snippet
        let statistics: Statistics?
        let brandingSettings : BrandingSettings?
        
        // MARK: - Snippet
        struct Snippet: Codable {
            let title : String
            let description : String
            let thumbnails: Thumbnails
            
            // MARK: - Thumbnails
            struct Thumbnails: Codable {
                let medium : Default
                let high: Default
                
                // MARK: - Default
                struct Default: Codable {
                    let url: String
                    let width : Int
                    let height: Int
                }
            }
        }
        
        // MARK: - Statistics
        struct Statistics: Codable {
            let viewCount: String
            let subscriberCount: String
            let hiddenSubscriberCount: Bool
            let videoCount: String
        }
        
        struct BrandingSettings : Codable{
            let image: Image
            
            struct Image : Codable{
                let bannerExternalUrl : String
            }
        }
    }
}
