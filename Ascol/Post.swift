//
//  Post.swift
//  Ascol
//
//  Created by Jamel Reid  on 5/6/17.
//  Copyright © 2017 Jamel Reid . All rights reserved.
//

import Foundation

class Post {
    
    private var _title: String!
    private var _likes: String!
    private var _views: String!
    private var _date: Double!
    private var _postId: String!
    private var _type: String!
    private var _tags: String!
    private var _category: String!
    private var _course: String!
    private var _location: String!
    private var _details: String!
    private var _comments: String!
    private var _creator: String!
    private var _imageURL: String!
    private var _commentId: String!
    
    var commentId: String {
        
        if _commentId == nil {
            _commentId = ""
        }
        
        return _commentId
    }
    
    var imageURL: String {
        if _imageURL == nil {
            _imageURL = ""
        }
        
        return _imageURL
    }
    
    var title: String {
        if _title == nil {
            _title = ""
        }
        
        return _title
    }
    
    var likes: String {
        if _likes == nil {
            _likes = ""
        }
        
        return _likes
    }
    
    var views: String {
        if _views == nil {
            _views = ""
        }
        
        return _views
    }
    
    var date: Double {
        if _date == nil {
            _date = 0.0
        }
        
        return _date
    }
    
    var postId: String {
        if _postId == nil {
            _postId = ""
        }
        
        return _postId
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        
        return _type
    }
    
    var category: String {
        if _category == nil {
            _category = ""
        }
        
        return _category
    }
    
    var course: String {
        if _course == nil {
            _course = ""
        }
        
        return _course
    }
    
    var location: String {
        if _location == nil {
            _location = ""
        }
        
        return _location
    }
    
    var details: String {
        if _details == nil {
            _details = ""
        }
        
        return _details
    }
    
    var comments: String {
        if _comments == nil {
            _comments = ""
        }
        
        return _comments
    }
    
    var creator: String {
        if _creator == nil {
            _creator = ""
        }
        
        return _creator
    }
    
    var tags: String {
        
        if _tags == nil {
            _tags = ""
        }
        
        return _tags
    }
    
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        self._postId = postKey
        
        if let title = postData["title"] as? String {
            self._title = title
        }
        
        if let type = postData["type"] as? String {
            self._type = type
        }
        
        if let category = postData["category"] as? String {
            self._category = category
        }
        
        if let creator = postData["creator"] as? String {
            self._creator = creator
        }
        
        if let course = postData["course"] as? String {
            self._course = course
        }
        
        if let date = postData["date"] as? Double {
            self._date = date
        }
        
        if let imageUrl = postData["imageURL"] as? String {
            self._imageURL = imageUrl
        }
        
        if let likes = postData["likes"] as? Int {
            self._likes = "\(likes)"
        }
        
        if let views = postData["views"] as? Int {
            self._views = "\(views)"
        }
        
        if let location = postData["location"] as? String {
            self._location = location
        }
        
        if let details = postData["details"] as? String {
            self._details = details
        }
        
        if let comments = postData["comments"] as? String {
            self._comments = comments
        }
        
        if let commentId = postData["commentId"] as? String {
            self._commentId = commentId
        }
        
        if let tags = postData["tags"] as? String {
            self._tags = tags
        }
        
        
    }
    
}
