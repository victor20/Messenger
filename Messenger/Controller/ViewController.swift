
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var nameLabel: UIBarButtonItem!
    
    var threads: [ThreadModel] = []
    var model: Model!
    var currentUser: UserModel!
    var threadId: String!
    var currentPartner: UserModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.rowHeight = UITableView.automaticDimension
        mainTableView.estimatedRowHeight = 40
        addAuthStateNotificationObserver()
        dbStateNotificationObserver()
        fetchCurrentUserFromModel()
        fetchThreadsFromModel()
    }
    
    //-----------------------------------------------------------------------------------
    
    func addAuthStateNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(authStateUpdateRecived), name: NSNotification.Name("authStateUpdate"), object: nil)
    }
    
    func dbStateNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(dbStateUpdateRecived), name: NSNotification.Name("dbStateUpdate"), object: nil)
    }
    
    @objc private func authStateUpdateRecived() {
    }
    
    @objc private func dbStateUpdateRecived() {
        fetchThreadsFromModel()
        
        mainTableView.reloadData()
    }
    
    //-----------------------------------------------------------------------------------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainToNewCon" {
            let destVC = segue.destination as! NewConversationViewController
            destVC.model = self.model
        } else if segue.identifier == "mainTillCon" {
            let destVC = segue.destination as! ConversationViewController
            destVC.threadId = self.threadId
            destVC.partner = self.currentPartner
            destVC.model = self.model
        }
    }
    
    @IBAction func logOut(_ sender: UIBarButtonItem) {
        model.signout()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func newButton(_ sender: Any) {
        performSegue(withIdentifier: "mainToNewCon", sender: nil)
    }
    
    func fetchThreadsFromModel() {
        self.threads = model.getThreads()
    }
    
    func fetchCurrentUserFromModel() {
        self.currentUser = model.getCurrentUser()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return threads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! MainTableViewCell
        cell.set(thread: threads[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.threadId = threads[indexPath.row].threadId
        self.currentPartner = threads[indexPath.row].partners[0]
        self.performSegue(withIdentifier: "mainTillCon", sender: nil)
    }
    
    @objc internal func userStateDidChange() {
        
    }
}


