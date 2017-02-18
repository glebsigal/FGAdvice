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
    
    func getRandomAdvice(completionHandler: @escaping (_ advice: Advice?, _ error: NSError?) -> Void) {
        let endPoint = "random"
        apiHelper.sendRequest(URL: endPoint, completionHandler:
            { (response, error) in
                if error == nil
                {
                    let json = JSON(response)
                    guard let advice = Mapper<Advice>().map(JSON: json.rawValue as! [String : Any]) else
                    {
                        completionHandler(nil, NSError(domain: "Atlas", code: 99, userInfo: nil))
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
