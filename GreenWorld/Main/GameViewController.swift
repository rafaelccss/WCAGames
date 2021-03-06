import UIKit
import SpriteKit
import GameplayKit

protocol HandleWithScenes {
    func callOptionScene()
    func callPowerScene()
    func restartScene()
    func quitGame()
    func didSelectPower(_ power: Powers)
}

class GameViewController: UIViewController {
    
    var optionScene: GameOverScene?
    var gameScene: GameScene?
    var powerScene: PowersScene?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateGameScene()
        self.powerScene = PowersScene(size: self.view.frame.size, powers: [.Guaraci, .Tupã])
        self.optionScene = GameOverScene(size: self.view.frame.size, option: .restart)
        optionScene?.handle = self
        powerScene?.handle = self
    }
    
    func generateGameScene() {
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
    }
    
    func presentPauseScene() {
        let transitionFadeLength = 0.3
        let transitionFadeColor = UIColor.black
        let pauseTransition = SKTransition.fade(with: transitionFadeColor, duration: transitionFadeLength)
        pauseTransition.pausesOutgoingScene = true
        
        let currentSKView = view as! SKView
        currentSKView.presentScene(optionScene!, transition: pauseTransition)
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

    func callPowerScene() {
        let transitionFadeLength = 0.3
        let transitionFadeColor = UIColor.black
        let pauseTransition = SKTransition.fade(with: transitionFadeColor, duration: transitionFadeLength)
        pauseTransition.pausesOutgoingScene = true
        
        let currentSKView = view as! SKView
        currentSKView.presentScene(powerScene!, transition: pauseTransition)
    }
    
    func didSelectPower(_ power: Powers) {
        gameScene?.entityManager.currentPower = power
        unpauseGame()
    }
    
    func quitGame() {
        self.dismiss(animated: false, completion: nil)
    }
    
    func restartScene() {
        gameScene?.restartGame()
        unpauseGame()
    }
    
    func callOptionScene() {
        presentPauseScene()
    }
    
    
}
