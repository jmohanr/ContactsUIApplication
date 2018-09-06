//
//  WebServiceClass.swift
//  ContacsUIApplication
//
//  Created by Jagan Mohan on 05/09/18.
//  Copyright © 2018 Jagan Mohan. All rights reserved.
//

import Foundation
import UIKit

class APIService: NSObject {
    
    /// CALLING THE Get METHOD API
    static func fetchingCountryCodes(url:String,completion: @escaping ([[String:AnyObject]])->() ) {
        guard let url = URL(string: url) else { return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else { return  }
            guard let data = data else { return}
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [[String:AnyObject]] {
                    
                    DispatchQueue.main.async {
                        completion(json )
                    }
                }
            }
            catch let error as NSError {
                print("json error: \(error.localizedDescription)")
            }
            }.resume()
}

}
