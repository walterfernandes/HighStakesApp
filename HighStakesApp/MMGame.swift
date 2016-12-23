
import Foundation
import UIKit

enum MMSolutionChoices {
    case black
    case gray
    case green
    case blue
    case yellow
    case red
    
    static func getAll () -> [MMSolutionChoices] {
        return [.black, .gray, .green, .blue, .yellow, .red]
    }
    
    func color () -> UIColor {
        switch self {
        case .black:
            return UIColor.black
        case .gray:
            return UIColor.gray
        case .green:
            return UIColor.green
        case .blue:
            return UIColor.blue
        case .yellow:
            return UIColor.yellow
        case .red:
            return UIColor.red
        }
    }
    
    func value () -> String {
        switch self {
        case .black:
            return "Black"
        case .gray:
            return "Gray"
        case .green:
            return "Green"
        case .blue:
            return "Blue"
        case .yellow:
            return "Yellow"
        case .red:
            return "Red"
        }
    }
}

enum MMAnalysisResultType {
    case right
    case present
    case wrong
}

class MMGame {
    
    static let solutionLength = 4
    
    var solution: [MMSolutionChoices]
    var startTime: NSDate
    var maxGuesses: Int
    var guesses = [[MMSolutionChoices]]()
    var findSolution = false
    
    convenience init(maxGuesses: Int) {
        self.init(MMGame.getRadonSolution(), maxGuesses: maxGuesses)
    }
    
    init(_ withSolution: [MMSolutionChoices], maxGuesses: Int) {
        startTime = NSDate()
        solution = withSolution
        
        self.maxGuesses = maxGuesses
    }
    
    func test(_ guess: [MMSolutionChoices?]) -> Bool {

        if (isGameFinished()) {
            return false
        }
        
        for item in guess {
            if item == nil {
                return false
            }
        }
        
        guesses.insert((guess as! [MMSolutionChoices]), at: 0)
        
        findSolution = (solution == (guess as! [MMSolutionChoices]))
        
        return findSolution
    }
    
    func analyze(_ guess: [MMSolutionChoices]) -> [MMAnalysisResultType] {
        
        var results = [MMAnalysisResultType]()
        
        for i in 0 ..< solution.count {
            let solutionItem = solution[i]
            let guessItem = guess[i]
            
            if solutionItem == guessItem {
                results.append(.right)
            } else if solution.contains(guessItem) {
                results.append(.present)
            } else {
                results.append(.wrong)
            }
        }
     
        return results
    }
    
    func isGameFinished() -> Bool {
        if (findSolution) {
            return true
        } else if (guesses.count >= maxGuesses) {
            return true
        } else {
            return false
        }
    }
    
    class func getRadonSolution() -> [MMSolutionChoices] {
        var elements = [MMSolutionChoices]();
        
        while elements.count < MMGame.solutionLength {
            let choice = Int(arc4random_uniform(UInt32(MMSolutionChoices.getAll().count)))
            let pick = MMSolutionChoices.getAll()[choice]
            if !elements.contains(pick) {
                elements.append(pick)
            }
        }
        
        return elements
    }
}
