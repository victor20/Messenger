
import Foundation
import Firebase

struct MessageFromSnap {
    let messageId: String
    let sentToId: String
    let sentFromId: String
    let timeStamp: String
    let msgText: String
    
    init(snapShot: DataSnapshot) {
        let snapValues = snapShot.value as? NSDictionary
        self.messageId = (snapShot.key as? String)!
        self.sentToId = (snapValues!["sentToId"] as? String)!
        self.sentFromId = (snapValues!["sentFromId"] as? String)!
        self.timeStamp = (snapValues!["timeStamp"] as? String)!
        self.msgText = (snapValues!["msgText"] as? String)!
    }
}
