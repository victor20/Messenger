import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

protocol DBHandlerDelegate: class {
    func updateAuthState(authState: Bool, currentUser: UserModel)
    func addMessage(threadId: String, partnerId: String, messageId: String, partner: UserModel, message: MessageModel)
    func setModelSearchResults(users: [UserModel])
    func allertMainView(message: String)
    func allertRegisterView(message: String)
    func updateThreadId(threadId: String)
}

class DatabaseHandler  {
    weak var dbControllerD: DBHandlerDelegate?
    var dbRefUsers: DatabaseReference!
    var dbRefThreads: DatabaseReference!
    var currentUserId: String!
    var currentUser: UserModel!
    var users = [UserModel]()
    
    init() {
        dbRefUsers = Database.database().reference().child("users")
        dbRefThreads = Database.database().reference().child("threads")
        startFireBaseAuthStateChangeListener()
    }
    
    func authStateChange(currentUser: UserModel) {
        dbControllerD?.updateAuthState(authState: true, currentUser: currentUser)
    }
    
    func dBStateChange(threadId: String, partnerId: String, messageId: String, partner: UserModel, message: MessageModel) {
        dbControllerD?.addMessage(threadId: threadId, partnerId: partnerId, messageId: messageId, partner: partner, message: message)
    }
    
    func setSearchResult(users: [UserModel]) {
        dbControllerD?.setModelSearchResults(users: users)
    }
    
    func setThreadId(threadId: String) {
        dbControllerD?.updateThreadId(threadId: threadId)
    }
    
    //-----------------------------------------------------------------------------------
    
    func startFireBaseAuthStateChangeListener() {
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                self.getCurrentUser()
            }
        }
    }
    
    func getCurrentUser() {
        self.currentUserId = Auth.auth().currentUser?.uid
        dbRefUsers.child(self.currentUserId).observeSingleEvent(of: .value, with: { ( snapshot ) in
            
            DispatchQueue.main.async(execute: {
                if let user = UserModel(snapShot: snapshot) {
                    self.currentUser = user
                    self.authStateChange(currentUser: self.currentUser)
                }
            })
        }, withCancel: nil)
    }
    
    func register(email: String, password: String, name: String ) {
        Auth.auth().createUser(withEmail: email, password: password) { aRes, error in
            if let error = error {
                self.dbControllerD?.allertRegisterView(message: error.localizedDescription)
            } else {
                guard let user = aRes?.user else { return }
                let userValues = ["name": name, "email": email]
                Database.database().reference().child("users").child(user.uid).updateChildValues(userValues)
            }
        }
    }
    
    func signIn(email: String, password: String) {
        
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error = error, user == nil {
                self.dbControllerD?.allertMainView(message: error.localizedDescription)
            } else {
            }
        }
    }
    
    func searchForUsers() {
        dbRefUsers.observeSingleEvent(of: .value, with: { (snapshot ) in
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                if let user = UserModel(snapShot: rest) {
                    self.users.append(user)
                }
            }
            DispatchQueue.main.async(execute: {
                self.setSearchResult(users: self.users)
            })
        }, withCancel: nil)
    }
    
    func sendMessage(threadId: String, partnerId: String, MessageText: String) {
        
        let currentThreadRef: DatabaseReference!
        let userId = Auth.auth().currentUser?.uid
        let timeStamp = String(NSDate().timeIntervalSince1970)
        var firstMessage: Bool!
        
        if threadId == "" {
            currentThreadRef = dbRefThreads.childByAutoId()
            firstMessage = true
        } else {
            currentThreadRef = dbRefThreads.child(threadId)
            firstMessage = false
        }
        
        let thK = currentThreadRef.key
        let msgDict = ["msgText": MessageText, "sentToId": partnerId, "sentFromId": userId, "timeStamp": timeStamp]
        
        currentThreadRef.child("messages").childByAutoId().updateChildValues(msgDict) { (error, ref) in
            if error == nil {
                self.addThreadToUser(userId: userId!, partnerId: partnerId, thK: thK!, firstMessage: firstMessage)
            }
        }
    }
    
    func addThreadToUser(userId: String, partnerId: String, thK: String, firstMessage: Bool) {
        self.dbRefUsers.child(userId).child("threads").child(thK).updateChildValues(["partnerId": partnerId]) { (error, ref) in
            if error == nil {
                self.addThreadToPartner(userId: userId, partnerId: partnerId, thK: thK, firstMessage: firstMessage)
            }
        }
    }
    
    func addThreadToPartner(userId: String, partnerId: String, thK: String, firstMessage: Bool) {
        self.dbRefUsers.child(partnerId).child("threads").child(thK).updateChildValues(["partnerId":
            userId])  { (error, ref) in
            if error == nil {
                if firstMessage == true {
                    DispatchQueue.main.async(execute: {
                        self.dbControllerD?.updateThreadId(threadId: thK)
                    })
                }
            }
        }
    }
    
    func startObserveThreads() {
        dbRefUsers.child(currentUserId).child("threads").observe(.childAdded, with:{
            (threadSnapshot) in
            
            let threadId = threadSnapshot.key
            let snapValues = threadSnapshot.value as? NSDictionary
            let partnerId = snapValues!["partnerId"] as? String
            self.observePartnerForThread(partnerId: partnerId!, threadId:  threadId)
        }, withCancel: nil)
    }
    
    func observePartnerForThread(partnerId: String, threadId: String) {
        dbRefUsers.child(partnerId).observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            if let partner = UserModel(snapShot: snapshot) {
                self.observeMessagesForThread(partnerId: partnerId, threadId: threadId, partner: partner)
            }
            
        }, withCancel: nil)
    }
    
    func observeMessagesForThread(partnerId: String, threadId: String, partner: UserModel) {
        dbRefThreads.child(threadId).child("messages").observe(.childAdded, with:{
            (snapshot) in
            
            let message = MessageModel(snapShot: snapshot)
            DispatchQueue.main.async(execute: {
                self.dBStateChange(threadId: threadId, partnerId: partnerId, messageId: message.messageId, partner: partner, message: message)
            })
        }, withCancel: nil)
    }
    
    func signout() {
        do {
            try Auth.auth().signOut()
        } catch (let error) {
            
        }
    }
}
