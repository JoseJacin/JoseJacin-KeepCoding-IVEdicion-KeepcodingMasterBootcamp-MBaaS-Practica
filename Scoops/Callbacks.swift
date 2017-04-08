//
//  Callback.swift
//  Scoops
//
//  Created by Jose Sanchez Rodriguez on 8/4/17.
//  Copyright © 2017 COM. All rights reserved.
//

import Foundation

struct Callback {
    
    var done: Bool
    var message: String
    
    init(done: Bool, message: String){
        self.done = done
        self.message = message
    }
    
    var description : String {
        if self.done {
            return "Operation OK: " + self.message
        }else{
            return "Operation KO: " + self.message
        }
    }
}
