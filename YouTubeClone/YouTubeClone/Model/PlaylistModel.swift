//
//  PlaylistModel.swift
//  YouTubeClone
//
//  Created by Victor Roldan on 22/02/22.
//

import Foundation

struct PlaylistModel: Decodable{
    let kind : String
    let etag : String
    let pageInfo : PageInfo
    let items : [Item]
    
    struct Item: Decodable{
        let kind: String
        let etag: String
        let id: String
        let snippet : Snippet
        let contentDetails : ContentDetails
        
        struct Snippet: Decodable {
            let publishedAt : String
            let channelId : String
            let title : String
            let description : String
            let thumbnails: Thumbnails
            let channelTitle: String
            
            struct Thumbnails: Decodable{
                let medium : Medium
                
                struct Medium: Decodable{
                    let url : String
                    let width : Int
                    let height : Int
                }
            }//Thumbnails

            
        }//Snippet
        
        struct ContentDetails: Decodable{
            let itemCount : Int
        }//ContentDetails
        
    }//items
    
    
    struct PageInfo : Decodable{
        let totalResults : Int
        let resultsPerPage : Int
    }//PageInfo
}
