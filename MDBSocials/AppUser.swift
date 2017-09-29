//
//  AppUser.swift
//  MDBSocials
//
//  Created by Vineeth Yeevani on 9/26/17.
//  Copyright © 2017 Vineeth Yeevani. All rights reserved.
//

import Foundation

class AppUser {
    var name: String?
    var userID: String?
    
    init(id: String, userDict: [String:Any]?){
        self.userID = id
        if userDict != nil {
            if let name = userDict!["name"] as? String {
                self.name = name
            }
        }
    }
}
