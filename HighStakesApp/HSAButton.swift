
import UIKit

@IBDesignable
class HSAButton: UIButton {
    
    override var isHighlighted: Bool {
        didSet {
            
            if (isHighlighted == true) {
                
                if let color = backgroundColor {
                    layer.shadowColor = color.cgColor
                }
                
            } else {

                layer.shadowColor = shadowColor?.cgColor
                
            }
        }
    }

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
    
}
