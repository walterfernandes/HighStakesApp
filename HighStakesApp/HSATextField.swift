
import UIKit
import CoreGraphics

@IBDesignable
class HSATextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10);

    @IBInspectable var shadowColor: UIColor? {
        didSet {
            layer.shadowColor = shadowColor?.cgColor
        }
    }
    
    override func layoutSubviews () {
        super.layoutSubviews()
        
        layer.cornerRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 1
        layer.shadowRadius = 0.5
        
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}
