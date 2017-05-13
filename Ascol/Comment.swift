//
//  Comment.swift
//  Ascol
//
//  Created by Jamel Reid  on 5/12/17.
//  Copyright © 2017 Jamel Reid . All rights reserved.
//

import Foundation

class Comment {
    private var _message: String!
    private var _creator: String!
    private var _date: Double!
    
    var message: String {
        
        if _message == nil {
            _message = ""
        }
        
        return _message
    }
    
    var creator: String {
        
        if _creator == nil {
            _creator = ""
        }
        
        return _creator
    }
    
    var date: Double {
        
        if _date == nil {
            _date = 0.0
        }
        
        return _date
    }
    
    init(commentData: Dictionary<String, AnyObject>) {
        
        if let message = commentData["message"] as? String {
            self._message = message
        }
        
        if let creator = commentData["creator"] as? String {
            self._creator = creator
        }
        
        if let date = commentData["date"] as? Double {
            self._date = date
        }
    }
}
