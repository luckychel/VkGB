//
//  WebRequest.swift
//  homeWork_1
//
//  Created by Александр Кукоба on 09.04.2023.
//  Copyright © 2023 Кукоба Александр. All rights reserved.
//

import Foundation
import Alamofire

struct WebRequest {
    var method: HTTPMethod
    var url: String
    var parameters: Parameters
}

extension WebRequest: CustomStringConvertible {
    
    var description: String {
        return "WebRequest: method \(method.rawValue), url: \(url), parameters: \(parameters)"
    }
}
