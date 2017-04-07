//
//  Errors.swift
//  Scoops
//
//  Created by Jose Sanchez Rodriguez on 7/4/17.
//  Copyright © 2017 COM. All rights reserved.
//

import Foundation

enum ScoopsError : Error{
    case wrongUrlFormatForJSONResource
    case resourcePointedByUrlNotReachable
    case wrongJsonFormat
    case NotInLibrary
}

enum PDFError: Error{
    case invalidURL
    case notAPDF
}
