//
//  Post.swift
//  Scoops
//
//  Created by Jose Sanchez Rodriguez on 7/4/17.
//  Copyright © 2017 COM. All rights reserved.
//

import Foundation
import Firebase

class Post: NSObject{
    
    var title: String
    var desc: String
    var photo: String
    var lat: String
    var lng: String
    var useruid: String
    var email: String
    var published: Bool
    var Rating: Int
    var Rated: Int
    var creationDate: String
    var cloudRef: String?
    
    init(title: String, desc: String, lat: String, lng: String, useruid: String, email: String, published: Bool){
        self.title = title
        self.desc = desc
        self.photo = ""
        self.lat = lat
        self.lng = lng
        self.useruid = useruid
        self.email = email
        self.published = published
        self.Rating = 0
        self.Rated = 0
        self.creationDate = Date().description
        self.cloudRef = nil
    }
    
    init(snapshot: FIRDataSnapshot?){
        self.title = (snapshot?.value as? [String:Any])?["title"] as! String
        self.desc = (snapshot?.value as? [String:Any])?["desc"] as! String
        self.photo = (snapshot?.value as? [String:Any])?["photo"] as! String
        self.lat = (snapshot?.value as? [String:Any])?["lat"] as! String
        self.lng = (snapshot?.value as? [String:Any])?["lng"] as! String
        self.useruid = (snapshot?.value as? [String:Any])?["useruid"] as! String
        self.email = (snapshot?.value as? [String:Any])?["email"] as! String
        self.published = (snapshot?.value as? [String:Any])?["published"] as! Bool
        self.Rating = (snapshot?.value as? [String:Any])?["Rating"] as! Int
        self.Rated = (snapshot?.value as? [String:Any])?["Rated"] as! Int
        self.creationDate = (snapshot?.value as? [String:Any])?["creationDate"] as! String
        self.cloudRef = snapshot?.key.description
    }
}
