//
//  Rating.swift
//  Scoops
//
//  Created by Jose Sanchez Rodriguez on 8/4/17.
//  Copyright © 2017 COM. All rights reserved.
//

import Foundation

import Firebase

class Rating: NSObject {
    
    var userid: String // En vez de FIRDatabaseReference? se utiliza como String para poder tener más libertad a la hora de manejarlo
    var rating: Int
    
    init(userid: String, rating: Int){
        self.userid = userid
        self.rating = rating
    }
    
    init(snapshot: FIRDataSnapshot?){
        self.userid = (snapshot?.key)! //Clave del usuario
        self.rating = snapshot?.value as! Int
    }
    
}
