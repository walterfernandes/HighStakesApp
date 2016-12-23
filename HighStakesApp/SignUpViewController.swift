
import UIKit
import Parse
import PKHUD

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: HSATextField!
    @IBOutlet weak var lastNameTextField: HSATextField!
    @IBOutlet weak var emailTextField: HSATextField!
    @IBOutlet weak var passwordTextFiel: HSATextField!
    
    @IBOutlet weak var bottomSpacingConstraint: NSLayoutConstraint!

    var isShowingKeyboard = false

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController!.setNavigationBarHidden(false, animated: animated)
    }
 
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MAR: Target
    
    @IBAction func signUpButtonTouchUpInside(_ sender: Any) {
        
        let firstname = (firstNameTextField.text ?? "")
        let lastname = (lastNameTextField.text ?? "")
        let email = (emailTextField.text ?? "")
        let password = (passwordTextFiel.text ?? "")
        var errorMessage: String? = nil
        
        
        if firstname.isEmpty {
            errorMessage = "O campo 'FIRST NAME' deve ser preenchido!"
        }
        else if lastname.isEmpty {
            errorMessage = "O campo 'LAST NAME' deve ser preenchido!"
        }
        else if email.isEmpty || email.isValidEmail() == false {
            errorMessage = "O campo 'EMAIL' deve ser preenchido com um email válido!"
        }
        else if password.isEmpty {
            errorMessage = "O campo 'PASSWORD' deve ser preenchido!"
        }
        
        if let msg = errorMessage {

            UIAlertController.present(viewController:self, title:self.title , message:msg, dissmisTitle:"OK")
    
        } else {
            
            let user = HSAUser()
            
            user.username = email
            user.email = email
            user.password = password
            user.setValue(firstname, forKey: "firstname")
            user.setValue(lastname, forKey: "lastname")
            
            HUD.show(.progress)
            user.signUpInBackground(block: { (succeed, error) in
                
                if ((error) != nil) {
                    HUD.hide()

                    UIAlertController.present(viewController:self, title:self.title , message:error?.localizedDescription, dissmisTitle:"OK")

                } else {
                    
                    HUD.flash(.success, onView: self.view, delay: 1.0, completion: { (completion) in
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.present(section: .home)
                    })
                    
                }
            })
            
        }
        
    }
    
    
    //MARL: TextField
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

    //MARK: Keyboard
    
    func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameHeight = endFrame?.size.height ?? 0.0
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            bottomSpacingConstraint?.constant = isShowingKeyboard ? endFrameHeight : 0.0
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    func keyboardWillShow (notification: NSNotification) {
        isShowingKeyboard = true
    }
    
    func keyboardWillHide (notification: NSNotification) {
        isShowingKeyboard = false
    }
    

}
