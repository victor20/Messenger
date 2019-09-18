
import Foundation

struct ThreadModel {
    var partners = [UserModel]()
    var messages = [MessageModel]()
    let threadId: String!
    var lastMessage: String?
    var lastMessageTimeStamp: String?
    
    
    init(threadId: String, lastMessage: String? = nil, lastMessageTimeStamp: String? = nil) {
        self.threadId = threadId
        self.lastMessage = lastMessage
        self.lastMessageTimeStamp = lastMessageTimeStamp
    }
    
    init(threadModel: ThreadModel) {
        self.partners = threadModel.partners
        self.threadId = threadModel.threadId
        self.lastMessage = threadModel.lastMessage
        self.lastMessageTimeStamp = threadModel.lastMessageTimeStamp
    }
}

