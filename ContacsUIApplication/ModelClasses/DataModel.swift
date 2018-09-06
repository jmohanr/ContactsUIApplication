//
//  DataModel.swift
//  ContacsUIApplication
//
//  Created by Admin on 06/09/2018.
//  Copyright © 2018 Jagan Mohan. All rights reserved.
//

import Foundation
class DataModel {
    
    var name: String?
    var emailId: String?
    var imageUrl:String?
    
    init(name: String?, emailId: String?,imageUrl:String?){
        self.name = name
        self.emailId = emailId
        self.imageUrl = imageUrl
        
}
}
