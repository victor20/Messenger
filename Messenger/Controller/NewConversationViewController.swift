
import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import Dispatch

class NewConversationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var newConTableView: UITableView!
    
    var users: [UserModel] = []
    var currentPartner: UserModel!
    var model: Model!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newConTableView.rowHeight = UITableView.automaticDimension
        newConTableView.estimatedRowHeight = 40
        dbStateNotificationObserver()
        searchForUsers() 
    }
    
    func dbStateNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(userListUpdatedRecived), name: NSNotification.Name("userListUpdated"), object: nil)
    }
    
    @objc func userListUpdatedRecived() {
        users = model.getSearchResults()
        newConTableView.reloadData()
    }
    
    func searchForUsers() {
        model.searchForUsers()
    }
    
    @IBAction func goBackButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewConToCon" {
            let destVC = segue.destination as! ConversationViewController
            destVC.partner = self.currentPartner
            print("NEWCONVERSATIONVIEWCONTROLLER: dump av partner som väljs för ny konversation")
            dump(self.currentPartner)
            
            destVC.model = self.model
            destVC.threadId = ""
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newConCell", for: indexPath) as! NewConViewCell
        
        cell.titleLabel.text = users[indexPath.row].name
        cell.subtitleLabel.text = users[indexPath.row].email
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentPartner = self.users[indexPath.row]
        performSegue(withIdentifier: "NewConToCon", sender: nil)
    }
}
