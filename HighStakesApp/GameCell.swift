//
//  GameCell.swift
//  HighStakesApp
//
//  Created by Walter Fernandes de Carvalho on 22/12/16.
//  Copyright © 2016 Walter Fernandes de Carvalho. All rights reserved.
//

import UIKit

class GameCell: UITableViewCell {

    @IBOutlet weak var firstButton: HSAGameButton!
    @IBOutlet weak var secondButton: HSAGameButton!
    @IBOutlet weak var thirdButton: HSAGameButton!
    @IBOutlet weak var fourthButton: HSAGameButton!
    
    @IBOutlet weak var firstResultButton: HSAGameButton!
    @IBOutlet weak var secondResultButton: HSAGameButton!
    @IBOutlet weak var thirdResultButton: HSAGameButton!
    @IBOutlet weak var fourthResultButton: HSAGameButton!

    @IBOutlet weak var testButton: HSAButton!
    
    var guessButtons : [HSAGameButton]! {
        return [firstButton, secondButton,thirdButton, fourthButton]
    }
    
    var resultButtons : [HSAGameButton]! {
        return  [firstResultButton, secondResultButton,thirdResultButton, fourthResultButton]
    }
    
    
}
