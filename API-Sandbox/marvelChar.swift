

import Foundation
import SwiftyJSON

struct marvelChar {
    let id: String
    let name: String
    let imageLink: String
    let imageExists: Bool
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.name = json["name"].stringValue
        if !json["thumbnail"]["path"].stringValue.containsString("image_not") && !json["thumbnail"]["path"].stringValue.containsString("4c002e0305708"){
        self.imageLink = json["thumbnail"]["path"].stringValue + "." + json["thumbnail"]["extension"].stringValue
        self.imageExists = true
        } else {
            self.imageLink = ""
            self.imageExists = false
        }
    }
}
