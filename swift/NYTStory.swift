//
//  NYTStory.swift
//  SwiftRealmGridController
//
//  Created by Adam Fish on 9/8/15.
//  Updated by Doron Katz on 3/19/17.
//  Copyright (c) 2015 Adam Fish. All rights reserved.
//

import RealmSwift
import Foundation

public class NYTStory: Object {
    public dynamic var section = ""
    
    public dynamic var subsection = ""
    
    public dynamic var title = ""
    
    public dynamic var abstract = ""
    
    public dynamic var urlString = ""
    
    public dynamic var byline = ""
    
    public dynamic var itemType = ""
    
    public dynamic var updatedDate = Date.distantPast
    
    public dynamic var createdDate: Date = Date.distantPast
    
    public dynamic var publishedDate = Date.distantPast
    
    public dynamic var materialTypeFacet = ""
    
    public dynamic var kicker = ""
    
    public dynamic var storyImage: NYTStoryImage?
    
    public var url: NSURL {
        return NSURL(string: self.urlString)!
    }
    
    public class func story(json: NSDictionary) -> NYTStory? {
        let story = NYTStory()
        
        if let section = json["section"] as? String {
            story.section = section
        }
        if let subsection = json["subsection"] as? String {
            story.subsection = subsection
        }
        if let title = json["title"] as? String {
            story.title = title
        }
        if let abstract = json["abstract"] as? String {
            story.abstract = abstract
        }
        if let urlString = json["url"] as? String {
            story.urlString = urlString
        }
        if let byline = json["byline"] as? String {
            story.byline = byline
        }
        if let itemType = json["item_type"] as? String {
            story.itemType = itemType
        }
        
        let dateFormatter = self.aDateFormatter
        
        if let updatedDateString = json["updated_date"] as? String {
            
            let cleanedString = NYTStory.cleanDateString(dateString: updatedDateString)
            
            if let updatedDate = dateFormatter.date(from: cleanedString) {
                story.updatedDate = updatedDate
            }
        }
        
        if let createdDateString = json["created_date"] as? String {
            
            let cleanedString = NYTStory.cleanDateString(dateString: createdDateString)
            
            if let updatedDate = dateFormatter.date(from: cleanedString) {
                story.createdDate = updatedDate as Date
            }
        }
        
        if let publishedDateString = json["published_date"] as? String {
            
            let cleanedString = NYTStory.cleanDateString(dateString: publishedDateString)
            
            if let updatedDate = dateFormatter.date(from: cleanedString) {
                story.publishedDate = updatedDate
            }
        }
        
        if let materialTypeFacet = json["material_type_facet"] as? String {
            story.materialTypeFacet = materialTypeFacet
        }
        
        if let kicker = json["kicker"] as? String {
            story.kicker = kicker
        }
        
        
        if let imageArray = json["multimedia"] as? NSArray {
            if imageArray.count > 0 {
                
                var imageDict: NSDictionary? = nil;
                
                if imageArray.count > 1 {
                    if let dict = imageArray[1] as? NSDictionary {
                        imageDict = dict
                    }
                }
                else if imageArray.count > 0 {
                    if let dict = imageArray[0] as? NSDictionary {
                        imageDict = dict
                    }
                }
                if let dict = imageDict {
                    
                    story.storyImage = NYTStoryImage.storyImage(json: dict)
                    
                    return story;
                }
            }
        }
        
        return nil;
    }
    
    public class func loadLatestStories(intoRealm realm: Realm, withAPIKey apiKey: String) {
        let config = realm.configuration
        
        
        DispatchQueue.main.async { () -> Void in
            let nytSections =
                [
                    "home",
                    "world",
                    "national",
                    "politics",
                    "nyregion",
                    "business",
                    "opinion",
                    "technology",
                    "science",
                    "health",
                    "sports",
                    "arts",
                    "fashion",
                    "dining",
                    "travel",
                    "magazine",
                    "realestate"
            ]
            
            for section in nytSections {
                let urlString = "https://api.nytimes.com/svc/topstories/v1/\(section).json?api-key=\(apiKey)"
                
                let url = URL(string: urlString)
                
                let topStoriesRequest = URLRequest(url: url!)
                
                URLSession.shared.dataTask(with: topStoriesRequest as URLRequest, completionHandler: { (data, response, error) -> Void in
                    
                    if error != nil {
                        return
                    }
                    
                    if data != nil {
                        let json = try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                        
                        if let results = json["results"] as? [NSDictionary] {
                            
                            let aRealm = try! Realm(configuration: config)
                            
                            aRealm.beginWrite()
                            
                            for storyJSON in results {
                                if let story = NYTStory.story(json: storyJSON) {
                                    aRealm.add(story, update: true)
                                }
                            }
                            try! aRealm.commitWrite()
                        }
                    }
                }).resume()
            }
        }
    }
    
    public class func stringFromDate(date: NSDate) -> String {
        return self.stringFormatter.string(from: date as Date)
    }
    
    private static var stringFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    private static var aDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        
        return dateFormatter
    }()
    
    private class func cleanDateString(dateString: String) -> String {
        let string = dateString as NSString
        
        let cleanedString = string.replacingOccurrences(of: ":", with: "", options: .literal, range: NSMakeRange(string.length - 5, 5))
        
        return cleanedString
    }
    
    override public static func ignoredProperties() -> [String] {
        return ["url"]
    }
    
    override public static func primaryKey() -> String? {
        return "title"
    }
}

public class NYTStoryImage: Object {
    
    public dynamic var urlString = ""
    
    public dynamic var format = ""
    
    public dynamic var height: Double = 0
    
    public dynamic var width: Double = 0
    
    public dynamic var type = ""
    
    public dynamic var subtype = ""
    
    public dynamic var caption = ""
    
    public dynamic var copyright = ""
    
    public var url: NSURL {
        return NSURL(string: self.urlString)!
    }
    
    override public static func ignoredProperties() -> [String] {
        return ["url","image"]
    }
    
    public class func storyImage(json: NSDictionary) -> NYTStoryImage? {
        let storyImage = NYTStoryImage()
        
        if let property = json["url"] as? String {
            storyImage.urlString = property
        }
        
        if let property = json["format"] as? String {
            storyImage.format = property
        }
        
        if let property = json["height"] as? Double {
            storyImage.height = property
        }
        
        if let property = json["width"] as? Double {
            storyImage.width = property
        }
        
        if let property = json["type"] as? String {
            storyImage.type = property
        }
        
        if let property = json["subtype"] as? String {
            storyImage.subtype = property
        }
        
        if let property = json["caption"] as? String {
            storyImage.caption = property
        }
        
        if let property = json["copyright"] as? String {
            storyImage.copyright = property
        }
        
        return storyImage;
    }
}
