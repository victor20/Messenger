
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore


class ConversationViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var model: Model!
    var currentUser: UserModel!
    var partner: UserModel!
    var messages: [MessageModel] = []
    var threadId: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        emailLabel.text = partner.name
        initKeyBoardNotifications()
        addAuthStateNotificationObserver()
        dbStateNotificationObserver()
        threadIdNotificationObserver()
        fetchCurrentUserFromModel()
        fetchMessagesFromModel()/Users/victorpregen/Dropbox/Xcode Project/Lab4MstTest/Lab4MstTest/Controller/NewConversationViewController.swift
    
    }
    
    deinit {
        deInitKeyBoardNotifications()
    }
    
    //-----------------------------------------------------------------------------------
    
    
    func addAuthStateNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(authStateUpdateRecived), name: NSNotification.Name("authStateUpdate"), object: nil)
    }
    
    func dbStateNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(dbStateUpdateRecived), name: NSNotification.Name("dbStateUpdate"), object: nil)
    }
    
    func threadIdNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(threadIdUpdateRecived), name: NSNotification.Name("updateThreadId"), object: nil)
    }
    
    @objc private func authStateUpdateRecived() {
        
    }
    
    @objc private func dbStateUpdateRecived() {
        fetchMessagesFromModel()
        collectionView.reloadData()
    }
    
    @objc private func threadIdUpdateRecived()
    {
        
        self.threadId = model.getCurrentThreadId()
        fetchMessagesFromModel()
        collectionView.reloadData()
    }
    
    //-----------------------------------------------------------------------------------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    @IBAction func logOutButton(_ sender: UIButton) {
    }
    
    @IBAction func goBackButton(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func fetchCurrentUserFromModel() {
        self.currentUser = model.getCurrentUser()
    }
    
    func fetchMessagesFromModel() {
        if threadId != "" {
            self.messages = model.getMessages(threadId: threadId)
        }
    }
    
    func sendMessage() {
        if threadId == "" {
            model.sendMessage(threadId: "", partnerId: partner.userId, MessageText: textField.text!)
        } else {
            model.sendMessage(threadId: threadId, partnerId: partner.userId, MessageText: textField.text!)
        }
        
    }
    
    //------------------------------------------------
    
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        //send()
        //threadRef.child("lastMessage").updateChildValues(["lastMessage": textField.text])
    }
    
    //------------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollCell", for: indexPath) as! CollectionViewCell
        
        var estWidth = estimateSize(text: messages[indexPath.item].msgText).width
        estWidth = estWidth.rounded(.towardZero)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let tmpCell = cell as! CollectionViewCell
        //tmpCell.width.constant = estimateSize(text: messages[indexPath.item].msgText).width + 11
    
}
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var heigth: CGFloat = 80
        
        heigth = estimateSize(text: messages[indexPath.item].msgText).height
        
        return CGSize(width: view.frame.width, height: heigth + 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func estimateSize(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0)], context: nil)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.text == "" {
            return true
        } else {
            sendMessage()
            textField.text = ""
            return true
        }
    }
    
    @objc func keybordWillChange(notification: Notification) {
        
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification ||
            notification.name == UIResponder.keyboardWillChangeFrameNotification  {
            view.frame.origin.y = -keyboardRect.height
        } else {
            view.frame.origin.y = 0
        }
        
    }
    
    func initKeyBoardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keybordWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keybordWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keybordWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func deInitKeyBoardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    
    
}
