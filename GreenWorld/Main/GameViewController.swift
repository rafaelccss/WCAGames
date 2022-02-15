import UIKit
import SpriteKit
import GameplayKit

protocol HandleWithScenes {
    func callOptionScene()
    func resumeScene()
    func quitGame()
    func didSelectPower(_ power: Powers)
}

class GameViewController: UIViewController {
    
    var optionScene: GameOverScene?
    var gameScene: GameScene?
    var powerScene: PowersScene?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            let scene = GameScene(size: view.frame.size)
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            self.gameScene = scene
            gameScene?.handle = self

            // Present the scene
            view.presentScene(scene)
            view.preferredFramesPerSecond = 30
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
        }
        self.powerScene = PowersScene(size: self.view.frame.size, powers: [.Guaraci, .Mboi, .Tupã])
        self.optionScene = GameOverScene(size: self.view.frame.size, option: .pause)
        optionScene?.handle = self
        powerScene?.handle = self
    }
    
    func presentPauseScene() {
        let transitionFadeLength = 0.3
        let transitionFadeColor = UIColor.black
        let pauseTransition = SKTransition.fade(with: transitionFadeColor, duration: transitionFadeLength)
        pauseTransition.pausesOutgoingScene = true
        
        let currentSKView = view as! SKView
        currentSKView.presentScene(powerScene!, transition: pauseTransition)
    }
    
    func unpauseGame() {
        let transitionFadeLength = 0.3
        let transitionFadeColor = UIColor.black
        let unpauseTransition = SKTransition.fade(with: transitionFadeColor, duration: transitionFadeLength)
        unpauseTransition.pausesIncomingScene = false
        
        let currentSKView = view as! SKView
        currentSKView.presentScene(gameScene!, transition: unpauseTransition)
    }


    override var shouldAutorotate: Bool {
        return true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension GameViewController: HandleWithScenes {
    func didSelectPower(_ power: Powers) {
        print(power)
    }
    
    func quitGame() {
        self.dismiss(animated: false, completion: nil)
    }
    
    func resumeScene() {
        unpauseGame()
    }
    
    func callOptionScene() {
        presentPauseScene()
    }
    
    
}
