
import UIKit
import Parse

class HSAUser: PFUser {
    
    var firstname: String? {
        set {
            setValue(firstname, forKey: "firstname")
        }
        get {
            return value(forKey: "firstname") as! String?
        }
    }
    
    var lastname: String? {
        set {
            setValue(lastname, forKey: "lastname")
        }
        get {
            return value(forKey: "lastname") as! String?
        }
    }

    class func isLoged () -> Bool {
        return (current() != nil)
    }
}
