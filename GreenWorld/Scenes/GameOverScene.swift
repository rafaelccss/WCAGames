import UIKit
import GameplayKit
import SpriteKit

enum OptionMenu: String {
    case pause = "Continue"
    case restart = "Restart"
}

class GameOverScene: SKScene {
    
    var center: CGPoint?
    var optionButton: SKLabelNode?
    var quitButton: SKLabelNode?
    var option: OptionMenu
    var handle: HandleWithScenes?
    
    override func didMove(to view: SKView) {
        setupScene()
    }
    
    init(size: CGSize, option: OptionMenu) {
        self.option = option
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupScene() {
        self.backgroundColor = .black.withAlphaComponent(0.4)
        self.center = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        self.isUserInteractionEnabled = false
        setUpSceneNodes()
        showButtons()
    }
    
    func setUpSceneNodes() {
        let pauseOffset: CGPoint = CGPoint(x: 0, y: 0)
        let endGameOffset = CGPoint(x: 0, y: 32)
        
        optionButton = SKLabelNode(text: option.rawValue)
        optionButton?.name = option.rawValue
        optionButton?.scene?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        optionButton?.position = CGPoint(x: self.center!.x + pauseOffset.x, y: self.center!.y + pauseOffset.y)
        optionButton?.alpha = 0
        //optionButton?.setScale(buttonScale)
        //optionButton?.isUserInteractionEnabled = true
        
        quitButton = SKLabelNode(text: "Quit")
        quitButton?.name = "Text"
        quitButton?.scene?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        quitButton?.position = CGPoint(x: self.center!.x + endGameOffset.x, y: self.center!.y - endGameOffset.y - optionButton!.frame.size.height)
        quitButton?.alpha = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if optionButton!.contains(location) {
                handle?.restartScene()
            } else if quitButton!.contains(location) {
                handle?.quitGame()
            }
        }
    }
    
    func showButtons() {
        let buttonFadeInTime = 0.25
        let pauseDelay = 1.0
        
        self.addChild(optionButton!)
        self.addChild(quitButton!)
        
        optionButton?.run(SKAction.fadeIn(withDuration: buttonFadeInTime))
        quitButton?.run(SKAction.fadeIn(withDuration: buttonFadeInTime))
        
        self.run(.sequence(
            [
                .wait(forDuration: pauseDelay),
                .run {
                    self.isUserInteractionEnabled = true
                }
            ]
        ))
    }
    
}
