//
//  NSObject.swift
//  Scoops
//
//  Created by Jose Sanchez Rodriguez on 8/4/17.
//  Copyright © 2017 COM. All rights reserved.
//

import Foundation


extension NSObject{
    // Función que conviente un Objeto Swift en un Diccionario
    // Extraído de Stackoverflow (http://stackoverflow.com/questions/31971256/how-to-convert-a-swift-object-to-a-dictionary)
    func toDict() -> [String:Any] {
        var dict = [String:Any]()
        let otherSelf = Mirror(reflecting: self)
        for child in otherSelf.children {
            if let key = child.label {
                dict[key] = child.value
            }
        }
        return dict
    }
}

extension NSObject {
    // Función que retorna el nombre de la clase como String
    // Extraído de Stackoverflow (http://stackoverflow.com/questions/24494784/get-class-name-of-object-as-string-in-swift)
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
