//
//  Advice.swift
//  FGAdvice
//
//  Created by Gleb Sigal on 18.02.17.
//  Copyright © 2017 dutchwheel. All rights reserved.
//

import Foundation
import ObjectMapper

class Advice: Mappable {
    var id : Int?
    var text : String?
    
    required init?(map: Map)
    { }
    
    func mapping(map: Map)
    {
        id <- map["id"]
        text <- map["text"]
    }
    
}
