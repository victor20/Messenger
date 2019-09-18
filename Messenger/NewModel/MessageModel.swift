
import Foundation
import Firebase

struct MessageModel {
    let messageId: String
    let sentToId: String
    let sentFromId: String
    let timeStamp: String
    let msgText: String
    
    init(messageId: String, sentToId: String, sentFromId: String, timeStamp: String, msgText: String) {
        self.messageId = messageId
        self.sentToId = sentToId
        self.sentFromId = sentFromId
        self.timeStamp = timeStamp
        self.msgText = msgText
    }
    
    init(snapShot: DataSnapshot) {
        let snapValues = snapShot.value as? NSDictionary
        self.messageId = (snapShot.key as? String)!
        self.sentToId = (snapValues!["sentToId"] as? String)!
        self.sentFromId = (snapValues!["sentFromId"] as? String)!
        self.timeStamp = (snapValues!["timeStamp"] as? String)!
        self.msgText = (snapValues!["msgText"] as? String)!
    }
}
