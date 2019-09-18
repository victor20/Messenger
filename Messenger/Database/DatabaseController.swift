import Foundation
import UIKit

protocol DBControllerDelegate: class {
    func authStateDBControllerToModel(authState: Bool, currentUser: UserModel)
    func dbAddMessage(threadId: String, partnerId: String, messageId: String, partner: UserModel, message: MessageModel)
    func setLatestSearchEntries(users: [UserModel])
    func setLatestThreadId(threadId: String)
}

class DatabaseController: DBHandlerDelegate  {
    
    var authState: String!
    let databaseHandler = DatabaseHandler()
    weak var dBControllerDelegate: DBControllerDelegate?
    
    init() {
        databaseHandler.dbControllerD = self
    }
    
    func databaseStartSynch () {
    
    }
    
    func updateAuthState(authState: Bool, currentUser: UserModel) {
        dBControllerDelegate?.authStateDBControllerToModel(authState: authState, currentUser: currentUser)
        
        NotificationCenter.default.post(name:
            NSNotification.Name("authStateUpdate"), object: nil)
    }
    
    func addMessage(threadId: String, partnerId: String, messageId: String, partner: UserModel, message: MessageModel) {
        dBControllerDelegate?.dbAddMessage(threadId: threadId, partnerId: partnerId, messageId: messageId, partner: partner, message: message)
        
        NotificationCenter.default.post(name:
            NSNotification.Name("dbStateUpdate"), object: nil)
    }
    
    func setModelSearchResults(users: [UserModel]) {
        dBControllerDelegate?.setLatestSearchEntries(users: users)
        
        NotificationCenter.default.post(name:
            NSNotification.Name("userListUpdated"), object: nil)
    }
    
    func allertMainView(message: String) {
        NotificationCenter.default.post(name:
            NSNotification.Name("mainViewAlert"), object: nil)
    }
    
    func allertRegisterView(message: String) {
        NotificationCenter.default.post(name:
            NSNotification.Name("registerViewAlert"), object: nil)
    }
    
    func updateThreadId(threadId: String) {
        dBControllerDelegate?.setLatestThreadId(threadId: threadId)
        NotificationCenter.default.post(name:
            NSNotification.Name("updateThreadId"), object: nil)
    }

    func register(email: String, password: String, name: String) {
        databaseHandler.register(email: email, password: password, name: name)
    }
    
    func singIn(email: String, password: String) {
        databaseHandler.signIn(email: email, password: password)
    }
    
    func searchForUsers() {
        databaseHandler.searchForUsers()
    }
    
    func startObserveThreads() {
        databaseHandler.startObserveThreads()
    }
    
    func sendMessage(threadId: String, partnerId: String, MessageText: String) {
        databaseHandler.sendMessage(threadId: threadId, partnerId: partnerId, MessageText: MessageText)
    }
    
    func signout() {
       databaseHandler.signout()
    }
}




