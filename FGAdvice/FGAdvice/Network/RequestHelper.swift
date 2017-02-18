//
//  RequestHelper.swift
//  FGAdvice
//
//  Created by Gleb Sigal on 18.02.17.
//  Copyright © 2017 dutchwheel. All rights reserved.
//

import Alamofire
import SwiftyJSON

typealias RequestBasicCompletionHandler = (_ response: NSDictionary?, _ error: NSError?) -> Void
typealias RequestSuccessOrNotComplectionHandler = (_ success: Bool, _ error: NSError?) -> Void
typealias ImageRequestSuccessHandler = (_ success: Bool, _ url:String) -> Void

class RequestHelper {
    let applicationBaseURL = "http://fucking-great-advice.ru/api/"
    var manager: SessionManager!
    
    init () {
        manager = SessionManager(configuration: .ephemeral)
    }
    
    func sendRequest(URL: String, completionHandler: @escaping RequestBasicCompletionHandler) {
        let startString = applicationBaseURL + URL
        let urlString = startString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) ?? startString
        
        manager.request(urlString, method: .get)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    completionHandler(value as? NSDictionary, nil)
                    print("Response:", value as? [String : AnyObject])
                case .failure(let error):
                    print(error.localizedDescription)
                    completionHandler(nil, error as NSError?)
                }
        }
}
}
