
import UIKit

class MainViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    /** GÖR DESSA PRIVATE */
    var model: Model!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addAuthStateNotificationObserver()
        dbStateNotificationObserver()
        signInAllertObserver()
        model = Model()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    //-----------------------------------------------------------------------------------
    
    func addAuthStateNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(authStateUpdateRecived), name: NSNotification.Name("authStateUpdate"), object: nil)
    }
    
    func dbStateNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(dbStateUpdateRecived), name: NSNotification.Name("dbStateUpdate"), object: nil)
    }
    
    func signInAllertObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(signInAllertRecived), name: NSNotification.Name("mainViewAlert"), object: nil)
    }
    
    @objc private func authStateUpdateRecived() {
        print("recived Authstate update")
        self.performSegue(withIdentifier: "MainVCToVC", sender: nil)
    }
    
    @objc private func dbStateUpdateRecived() {
        
    }
    
    @objc private func signInAllertRecived() {
        let alert = UIAlertController(title: "Login Failed", message: "Login Error", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    //-----------------------------------------------------------------------------------
    
    @IBAction func signInButton(_ sender: UIButton) {
        model.signIn(email: emailTextField.text!, passord: passwordTextField.text!)
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        performSegue(withIdentifier: "MainVCToRegVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MainVCToVC" {
            let destVC = segue.destination as! ViewController
            destVC.model = self.model
        
        } else if segue.identifier == "MainVCToRegVC" {
            let destVC = segue.destination as! RegisterViewController
            destVC.model = self.model
        }
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
}
