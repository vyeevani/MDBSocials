//
//  Post.swift
//  MDBSocials
//
//  Created by Vineeth Yeevani on 9/26/17.
//  Copyright © 2017 Vineeth Yeevani. All rights reserved.
//

import Foundation
import Firebase

class Post{
    var text: String?
    var date: String?
    var name: String?
    var poster: String?
    var id: String?
    var interested: [String]?
    var image : UIImage?
    init(id: String, postDict: [String:Any]?) {
        self.id = id
        if let text = postDict!["text"] as? String {
            self.text = text
        }
        if let date = postDict!["date"] as? String {
            self.date = date
        }
        if let name = postDict!["name"] as? String {
            self.name = name
        }
        if let poster = postDict!["poster"] as? String {
            self.poster = poster
        }
        if let interested = postDict!["interested"] as? [String] {
            print("1351345134523456234625")
            self.interested = interested
        }
    }
    
    func getProfilePic(withBlock: @escaping () -> ()){
        //print(self.name)
        let ref = Storage.storage().reference().child("/Posts/\(id!)")
        ref.getData(maxSize: 1 * 2048 * 2048) { (data, error) in
            if error != nil {
            } else {
                self.image = UIImage(data: data!)
            }
            withBlock()
        }
    }
}
