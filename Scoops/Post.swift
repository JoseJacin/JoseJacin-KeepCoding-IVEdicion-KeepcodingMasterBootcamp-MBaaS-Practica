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
    var published: Bool
    var numRatings: Int
    var cumulativeRating: Int
    var creationDate: String
    var userid: String
    var email: String
    var ratings: [Rating]? // Según la documentación de Firebase, lo recomendable es realizar una correcta estrucuración de los datos
    var cloudRef: String? // En vez de FIRDatabaseReference? se utiliza como String para poder tener más libertad a la hora de manejarlo
    
    // Referencias. Lo pongo aquí para tener una referencia en el futuro
    // Estrucutración de los datos en Firebase
    // https://firebase.google.com/docs/database/ios/structure-data#fanout
    // Implantación del sistema de puntuaciones
    // https://groups.google.com/forum/#!topic/firebase-talk/EJYHxKKQ6ZA

    
    init(title: String, desc: String, lat: String, lng: String, published: Bool, userid: String, email: String){
        self.title = title
        self.desc = desc
        self.photo = ""
        self.lat = lat
        self.lng = lng
        self.published = published
        self.numRatings = 0
        self.cumulativeRating = 0
        self.creationDate = Date().description
        self.userid = userid
        self.email = email
        self.ratings = []
        self.cloudRef = nil
    }
    
    init(snapshot: FIRDataSnapshot?){
        self.title = (snapshot?.value as? [String:Any])?[constants.title] as! String
        self.desc = (snapshot?.value as? [String:Any])?[constants.desc] as! String
        self.photo = (snapshot?.value as? [String:Any])?[constants.photo] as! String
        self.lat = (snapshot?.value as? [String:Any])?[constants.lat] as! String
        self.lng = (snapshot?.value as? [String:Any])?[constants.lng] as! String
        self.published = (snapshot?.value as? [String:Any])?[constants.published] as! Bool
        self.numRatings = (snapshot?.value as? [String:Any])?[constants.numRatings] as! Int
        self.cumulativeRating = (snapshot?.value as? [String:Any])?[constants.cumulativeRating] as! Int
        self.creationDate = (snapshot?.value as? [String:Any])?[constants.creationDate] as! String
        self.userid = (snapshot?.value as? [String:Any])?[constants.userid] as! String
        self.email = (snapshot?.value as? [String:Any])?[constants.email] as! String
        self.cloudRef = snapshot?.key.description
        
        // Ratings
        let ratings = (snapshot?.value as? [String:Any])?[constants.ratings]
        self.ratings = ratings.map {
            let ratings = $0 as! [String:Int]
            return ratings.map({ Rating(userid: $0, rating: $1) })
        }
    }
}
