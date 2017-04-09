//
//  UIImageView.swift
//  Scoops
//
//  Created by Jose Sanchez Rodriguez on 7/4/17.
//  Copyright © 2017 COM. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        
        let image = UIImage(named: constants.defaultAvatar)
        self.image = image
        
        if urlString != "" {
            DispatchQueue.global().async {
                do{
                    let d = try getFileFrom(urlString: urlString)
                    DispatchQueue.main.async {
                        let image = UIImage(data: d)
                        self.image = image
                    }
                }catch{
                    
                }
            }
        }
        
    }
    
    public func imageFromServerURLThumb(urlString: String) {
        
        let image = UIImage(named: constants.defaultAvatar)
        self.image = image
        
        if urlString != "" {
            DispatchQueue.global().async {
                do{
                    let d = try getFileFrom(urlString: urlString)
                    DispatchQueue.main.async {
                        let image = UIImage(data: d)
                        self.image = image
                    }
                }catch{

                }
            }
        }
        
    }
    
}
