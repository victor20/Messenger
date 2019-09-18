
import Foundation

let databaseController = DatabaseController()

class Model: DBControllerDelegate {
    
    private var currentUser: UserModel!
    private var threads = [String: ThreadModel]()
    private var searchResults = [UserModel]()
    private var lastMessageId: String!
    private var currentThreadId: String!
    private var authenticated: Bool!
    
    init() {
        databaseController.dBControllerDelegate = self
    }
    
    func authStateDBControllerToModel(authState: Bool, currentUser: UserModel) {
       
        self.currentUser = currentUser
        self.authenticated = authState
        
        if authState {
            databaseController.startObserveThreads()
        }
    }
    
    func dbAddMessage(threadId: String, partnerId: String, messageId: String,
                      partner: UserModel, message: MessageModel) {
        
        if self.threads[threadId] == nil {
            self.threads[threadId] = ThreadModel(threadId: threadId, lastMessage: message.msgText, lastMessageTimeStamp: message.timeStamp)
            
            self.threads[threadId]?.messages.append(message)
            self.threads[threadId]?.partners.append(partner)
            
        } else {
            self.threads[threadId]?.lastMessage = message.msgText
            self.threads[threadId]?.lastMessageTimeStamp = message.timeStamp
            
            self.threads[threadId]?.messages.append(message)
            
        }
    }
    
    func setLatestSearchEntries(users: [UserModel]) {
        searchResults = users
    }
    
    func setLatestThreadId(threadId: String) {
        self.currentThreadId = threadId
    }
    
    
    //---------------------------------------------------
    
    func getCurrentUser() -> UserModel{
        return currentUser
    }
    
    func getMessages(threadId: String) -> [MessageModel]{
        return (threads[threadId]?.messages)!
    }
    
    func getThreads() -> [ThreadModel]{
        var returnArray = [ThreadModel]()
        for thread in threads {
            returnArray.append(ThreadModel(threadModel: thread.value))
        }
        returnArray.sort {
            $0.lastMessageTimeStamp! > $1.lastMessageTimeStamp!
        }
        return returnArray
    }
    
    func getSearchResults() -> [UserModel] {
        return searchResults
        
    }
    
    func getCurrentThreadId() -> String {
        return currentThreadId
    }
    
    func getlastMessageId() -> String {
        return lastMessageId
    }
    
    func setLastMessageId(lastMessageId: String) {
        self.lastMessageId = lastMessageId
    }
    
    func register(email: String, password: String, name: String) {
        databaseController.register(email: email, password: password, name: name)
    }
    
    func signIn(email: String, passord: String) {
        databaseController.singIn(email: email, password: passord)
    }
    
    func searchForUsers() {
        databaseController.searchForUsers()
    }
    
    func sendMessage(threadId: String, partnerId: String, MessageText: String) {
        databaseController.sendMessage(threadId: threadId, partnerId: partnerId, MessageText: MessageText)
    }
    
    func signout() {
        databaseController.signout()
    }
}

