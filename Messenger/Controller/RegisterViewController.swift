
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var model: Model!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInAllertObserver()
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func signInAllertObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(registrationInAllertRecived), name: NSNotification.Name("registerViewAlert"), object: nil)
    }
    
    @objc private func registrationInAllertRecived() {
        let alert = UIAlertController(title: "Login Failed", message: "Registration Error", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        model.register(email: emailTextField.text!, password: passwordTextField.text!, name: nameTextField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
