
import UIKit
import PKHUD

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newGameButton: HSAButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var game: MMGame? {
        didSet {
            tableView.isHidden = (game == nil)
            newGameButton.isHidden = !tableView.isHidden
            
            guessToTest = [nil, nil, nil, nil]
            titleLabel.text = "\(game!.guesses.count+1)/\(game!.maxGuesses)"
            tableView.reloadData()
        }
    }
    
    var guessToTest :[MMSolutionChoices?] = [nil, nil, nil, nil]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Actions

    @IBAction func newGameButtonTouchUpInside (sender: Any) {
        game = MMGame.init(maxGuesses: 10)
    }
    
    @IBAction func aboutTouchUpInside(_ sender: Any) {
        UIApplication.shared.openURL(NSURL(string: "https://en.wikipedia.org/wiki/Mastermind_(board_game)")! as URL)
    }

    @IBAction func logOutButtonTouchUpInside (sender: Any) {
        HSAUser.logOut()
        
        HUD.flash(.label("Até mais..."), onView: self.view, delay: 1.0, completion: { (completion) in
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.present(section: .login)
        })
    }
    
    func testButtonTouchUpInside (sender: Any) {

        if game!.test(guessToTest) {
            UIAlertController.present(viewController: self, title: "Congratulations!", message: "You Win!!!", dissmisTitle: "OK", dissmisHandler: {
                self.newGameButtonTouchUpInside(sender: self)
            })
        } else if game!.isGameFinished() {
            UIAlertController.present(viewController: self, title: "End game!", message: "Unfortunately you lose, try again!", dissmisTitle: "OK", dissmisHandler: {
                self.newGameButtonTouchUpInside(sender: self)
            })
        } else {
            titleLabel.text = "\(game!.guesses.count+1)/\(game!.maxGuesses)"
        }
        
        guessToTest = [nil, nil, nil, nil]
        tableView.reloadData()
    }

    func guessButtonTouchUpInside (sender: Any) {
        
        let guessItemIndex = (sender as! UIButton).tag
        let colorsMenu = UIAlertController(title: nil, message: "Choose the color", preferredStyle: .actionSheet)
        
        for i in 0 ..< MMSolutionChoices.getAll().count {
            
            let colorChoice = MMSolutionChoices.getAll()[i]
            
            let action = UIAlertAction(title: colorChoice.value(), style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                
                self.guessToTest[guessItemIndex] = colorChoice
                self.tableView.reloadData()
                
            })
            colorsMenu.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:nil)
        
        colorsMenu.addAction(cancelAction)
        
        self.present(colorsMenu, animated: true, completion: nil)
    }

    //MARK: TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if game == nil {
            return 0
        } else if game!.isGameFinished() {
            return game!.guesses.count
        } else {
            return game!.guesses.count+1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: GameCell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as! GameCell
        
        if (game!.isGameFinished() == false) && (indexPath.row == 0) {
            configEditableCell(cell)
        } else {
            configOtherCell(cell, indexPath: indexPath)
        }

        return cell
    }
    
    func configEditableCell (_ cell: GameCell) {
        
        cell.testButton.alpha = 1
        cell.testButton.addTarget(self, action: #selector(testButtonTouchUpInside(sender:)), for: UIControlEvents.touchUpInside)
        
        for guessButton in cell.guessButtons {
            guessButton.tag = cell.guessButtons.index(of: guessButton)!
            guessButton.addTarget(self, action: #selector(guessButtonTouchUpInside(sender:)), for: UIControlEvents.touchUpInside)
        }
        
        for i in 0 ..< guessToTest.count {
            
            if let item = guessToTest[i] {
                cell.guessButtons[i].backgroundColor = item.color()
            } else {
                cell.guessButtons[i].backgroundColor = UIColor.clear
            }
            
        }
    }
    
    func configOtherCell (_ cell: GameCell, indexPath: IndexPath) {

        var index = indexPath.row
        
        if (game!.isGameFinished() == false){
            index -= 1
        }
        
        let guess = game!.guesses[index]
        
        let analysis = game!.analyze(guess)
        
        for i in 0 ..< guess.count {
            cell.guessButtons[i].backgroundColor = guess[i].color()
        }
        
        for i in 0 ..< analysis.count {
            switch analysis[i] {
            case .present:
                cell.resultButtons[i].backgroundColor = UIColor.gray
                break
            case .right:
                cell.resultButtons[i].backgroundColor = UIColor.black
                break
            case .wrong:
                cell.resultButtons[i].backgroundColor = UIColor.clear
                break
            }
        }
        
        cell.testButton.alpha = 0.5
    }

}


