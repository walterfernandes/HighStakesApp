
import UIKit
import PKHUD

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var emailTextField: HSATextField!
    @IBOutlet weak var passwordTextField: HSATextField!
    
    @IBOutlet weak var bottomSpacingConstraint: NSLayoutConstraint!
    
    var isShowingKeyboard = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        loadVideo()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController!.setNavigationBarHidden(true, animated: animated)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    //MARK: Action
    
    @IBAction func loginButtonTouchUpInside(_ sender: Any) {
        
        let email = (emailTextField.text ?? "")
        let password = (passwordTextField.text ?? "")
        
        var errorMessage: String? = nil
        
        if email.isEmpty || email.isValidEmail() == false {
            errorMessage = "O campo 'EMAIL' deve ser preenchido com um email válido!"
        }
        else if password.isEmpty {
            errorMessage = "O campo 'PASSWORD' deve ser preenchido!"
        }
        
        if let msg = errorMessage {
            UIAlertController.present(viewController:self, title:self.title , message:msg, dissmisTitle:"OK")
        } else {
            
            HUD.show(.progress)
            HSAUser.logInWithUsername(inBackground: email, password: password, block: { (user, error) in
                
                if error != nil {
                    HUD.hide()
                    UIAlertController.present(viewController:self, title:self.title , message:error!.localizedDescription, dissmisTitle:"OK")
                } else {
                    HUD.flash(.success, onView: self.view, delay: 1.0, completion: { (completion) in
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.present(section: .home)
                    })
                }
                
            })
        }

    }
    
    //MARK: TextField
    
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
            bottomSpacingConstraint?.constant = !isShowingKeyboard ? endFrameHeight : 0.0
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
    
    //MARK: Functions
    
    func loadVideo () {

        let videoURL = "https://www.youtube.com/embed/ycPmjdwxIOQ";
        
        let embeddedString =  "<html><head><style>img{max-width:100%%;height:auto !important;width:auto !important;};</style></head><body style='margin:0; padding:0; background-color:#000000'><div style='text-align: center;'><iframe width=\"375\" height=\"217\" src=\"\(videoURL)\" frameborder=\"0\" allowfullscreen></iframe></div></body></html>"
        
        webView.scrollView.isScrollEnabled = false
        webView.loadHTMLString(embeddedString, baseURL: nil)
        
        
    }
}

