//
//  API.swift
//  OndergrondTV
//
//  Created by Supervisor on 29-11-16.
//  Copyright © 2016 Nerdvana. All rights reserved.
//

import Foundation
import UIKit

//MARK: - Error handeling
enum VideoResult {
    case Success([Video])
    case Failure(Error)
    case None
}

enum VideoError: Error {
    case InvalidJSONData
}

struct API {
    
    private static let apiKey = "AIzaSyCLgeLAV-oQCA2x63EuCUqcekrMVE9uzHE"
    private static let channelID = "UCcKJov9QO24HcGaP4w2wweg"
    private static let uploadsID = "UUcKJov9QO24HcGaP4w2wweg"
    private static let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    // MARK: - fetchVideoPlaylist
    /// Fetches the uploaded videos for the specified playlist.
    static func fetchVideoPlaylist(completionHandler: @escaping (VideoResult) -> ()) {
        
            if let url = URL(string: "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=50&playlistId=\(uploadsID)&key=\(apiKey)") {
                let task = self.session.dataTask(with: url, completionHandler: { (data, response, error) in
                    let result = processVideosFromPlaylist(data: data, error: error)
                    print(result)
                    completionHandler(result)
                })
                task.resume()
            }
        
    }
    
    // MARK: - processVideosFromPlaylist
    /// Processes the JSON data that is returned from the webservice.
    static func processVideosFromPlaylist(data: Data?, error: Error?) -> VideoResult {
        guard let jsonData = data else {
            return .Failure(error!)
        }
        return self.videosFromJSONData(data: jsonData)
    }
    
    // MARK: - videosFromJSONData
    /// Coverts an NSData instance to basic foundation objects.
    static func videosFromJSONData(data: Data) -> VideoResult {
        do {
            
            if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject] {
                
                if let videosArray = json["items"] as? [[String: AnyObject]] {
//                    print("these are the items: \(videosArray)")
                    var finalVideos = [Video]()
                    for videoJSON in videosArray {
                        if let video = videoFromJSONObject(json: videoJSON) {
                            finalVideos.append(video)
                        }
                    }
                    print(videosArray.count)
                    print(finalVideos.count)
                    if finalVideos.count == 0 && videosArray.count > 0 {
                        // We weren't able to parse any of the videos. Maybe the JSON format for videos has changed.
                        return .Failure(VideoError.InvalidJSONData)
                    }
                    return .Success(finalVideos)
                }
            }
        }
        catch let error {
            return .Failure(error)
        }
        return .None
    }
    
    // MARK: - videoFromJSONObject
    /// Parses a JSON dictionary into a Video instance.
    static func videoFromJSONObject(json: [String : AnyObject]) -> Video? {
        print(json)
        guard
            let videoID = json["id"] as? String,
            let videoTitle = json["snippet"]?["title"] as? String,
            let thumbnails = json["snippet"]?["thumbnails"] as? [String: AnyObject],
            let defaultThumbnail = thumbnails["default"] as? [String: AnyObject],
            let thumbnailURL = defaultThumbnail["url"] as? String
            
            else {
                return nil
        }
        return Video(ID: videoID, title: videoTitle, thumbnail: thumbnailURL)
    }

}
