//
//  Profile.swift
//  Ascol
//
//  Created by Jamel Reid  on 5/6/17.
//  Copyright © 2017 Jamel Reid . All rights reserved.
//

import Foundation

class Profile {
    private var _provider: String!
    private var _name: String!
    private var _imageUrl: String!
    
    var provider: String {
        set {
            _provider = newValue
        } get {
            if _provider == nil {
                _provider = ""
            }
            
            return _provider
        }
    }
    
    var name: String {
        set {
            _name = newValue
        } get {
            if _name == nil {
                _name = ""
            }
            
            return _name
        }
    }
    
    var imageUrl: String {
        set {
            _imageUrl = newValue
        } get {
            if _imageUrl == nil {
                _imageUrl = ""
            }
            
            return _imageUrl
        }
    }
    
    
}
