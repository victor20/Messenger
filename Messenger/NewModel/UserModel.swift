
import Foundation
import Firebase

struct UserModel {
    var userId: String
    var name: String
    var email: String
    
    init(userId: String, name: String, email: String) {
        self.userId = userId
        self.name = name
        self.email = email
    }
    
    init?(snapShot: DataSnapshot) {
        if let snapValues = snapShot.value as? NSDictionary {
            self.userId = snapShot.key
            self.name = (snapValues["name"] as? String)!
            self.email = (snapValues["email"] as? String)!
        } else {
            return nil
        }
    }
}
