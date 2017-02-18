//
//  ApiRoot.swift
//  FGAdvice
//
//  Created by Gleb Sigal on 18.02.17.
//  Copyright © 2017 dutchwheel. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper

class ApiRoot
{
    private var apiHelper: RequestHelper
    
    init()
    {
        self.apiHelper = RequestHelper()
    }
    
    func getRandomAdvice(tag:String,completionHandler: @escaping (_ advice: Advice?, _ error: NSError?) -> Void) {
        var endPoint = "random"
        switch tag {
        case "Без категории" :
             endPoint = "random"
        case "С цензурой":
            endPoint = "random/censored/"
        default:
             endPoint = "random_by_tag/"+tag
             break;
        }
        
        apiHelper.sendRequest(URL: endPoint, completionHandler:
            { (response, error) in
                if error == nil
                {
                    let json = JSON(response)
                    guard let advice = Mapper<Advice>().map(JSON: json.rawValue as! [String : Any]) else
                    {
                        completionHandler(nil, NSError(domain: "FGAdvice", code: 99, userInfo: nil))
                        return
                    }
                    completionHandler(advice, nil)
                } else
                {
                    completionHandler(nil, error)
                }
        })
    }
}
