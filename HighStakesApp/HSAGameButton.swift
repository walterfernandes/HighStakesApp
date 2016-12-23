//
//  HSAGameButton.swift
//  HighStakesApp
//
//  Created by Walter Fernandes de Carvalho on 22/12/16.
//  Copyright © 2016 Walter Fernandes de Carvalho. All rights reserved.
//

import UIKit

@IBDesignable
class HSAGameButton: UIButton {

    override func layoutSubviews () {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.size.height/2
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
        
    }

}
