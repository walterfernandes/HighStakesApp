
import UIKit
import Parse
import AVFoundation

enum AppDelegateSections {
    case home
    case login
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        initParse()
        configAudioSession()
        configNavigationBarAppearance()
        
        if (HSAUser.isLoged() == false) {
            present(section: .login)
        }
        
        return true
    }

    //MARK: Functions
    
    func initParse () {
        let configuration = ParseClientConfiguration {
            $0.applicationId = "oPKpbMQ15m5YQbbtlJDZ6IVrPNOqsNSQReR8gMPM"
            $0.clientKey = "zqrKd4cXRsxfFZQcrXgf92wNRgOMSQPsSJV34NP8"
            $0.server = "https://pg-app-vxz8xsel97kg1bw66hrxfiag75d0xe.scalabl.cloud/1/"
        }
        
        Parse.initialize(with: configuration)
    }
    
    func configNavigationBarAppearance () {
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        UINavigationBar.appearance().tintColor = UIColor.white
        UIBarButtonItem.appearance().tintColor = UIColor.white
    }
    
    func configAudioSession () {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        }
        catch let error as NSError {
            print(error)
        }
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch let error as NSError {
            print(error)
        }
    }
    
    func present (section: AppDelegateSections) {
        
        var storyBoard: UIStoryboard?
        
        switch section {
        case .login:
            storyBoard = UIStoryboard(name: "Login", bundle: nil)
            break
        case .home:
            storyBoard = UIStoryboard(name: "Main", bundle: nil)
            break
        }

        let viewController = storyBoard!.instantiateInitialViewController()
        
        window!.rootViewController = viewController
        
        UIView.transition(with: window!, duration: 0.3, options: UIViewAnimationOptions.transitionCrossDissolve, animations: nil, completion: nil)
    }
    
}

