//
//  DataService.swift
//  Ascol
//
//  Created by Jamel Reid  on 5/6/17.
//  Copyright © 2017 Jamel Reid . All rights reserved.
//

import Foundation
import Firebase


let DB_BASE = FIRDatabase.database().reference()
let STORAGE_BASE = FIRStorage.storage().reference()

class DataService {
    
    static let ds = DataService()
    
    // DB references
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_COURSES = DB_BASE.child("courses")
    private var _REF_TYPES = DB_BASE.child("type")
    private var _REF_CATEGORIES = DB_BASE.child("categories")
    
    //Storage references
    private var _REF_PROFILE_IMAGES = STORAGE_BASE.child("profile-pictures")
    
    var REF_POST_IMAGES: FIRStorageReference {
        return _REF_PROFILE_IMAGES
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_COURSES: FIRDatabaseReference {
        return _REF_COURSES
    }
    
    var REF_TYPES: FIRDatabaseReference {
        return _REF_TYPES
    }
    
    var REF_CATEGORIES: FIRDatabaseReference {
        return _REF_CATEGORIES
    }
    
    func createFirbaseDBUser(uid: String, userData: Dictionary<String, String>){
        _REF_USERS.child(uid).updateChildValues(userData)
    }
    
}
