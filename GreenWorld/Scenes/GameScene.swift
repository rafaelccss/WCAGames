import SpriteKit
import GameplayKit

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    // MARK: - Entities
    
    let player = Player()
    let enemy = Enemy()
    var entityManager: EntityManager!
    var lastXPlayerPosition:CGFloat = 0

    private var previousUpdateTime: TimeInterval = TimeInterval()
    var playerControlComponent: PlayerControlComponent? {
        player.component(ofType: PlayerControlComponent.self)
    }
    lazy var sceneCamera: SKCameraNode = {
        let camera = SKCameraNode()
        camera.setScale(1)
        return camera
    }()

    // MARK: - Gestures
    
    lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(attack))
    lazy var panGesture = UIPanGestureRecognizer(target: self, action: #selector(walk))
    
    let scoreLabel = SKLabelNode(text: "100")
    let heart = SKSpriteNode(imageNamed: "FullHeart")
    
    @objc
    func walk(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            playerControlComponent?.handle(direction: sender.direction)
            
        case .ended:
            playerControlComponent?.halt()
            
        default:
            break
        }
    }

    @objc
    func attack(){
        entityManager.playerAttack()
    }

    override func update(_ currentTime: TimeInterval) {
        self.sceneCamera.position.x = player.component(ofType: AnimatedSpriteComponent.self)!.spriteNode.position.x
        if player.component(ofType: AnimatedSpriteComponent.self)!.spriteNode.position.y < self.frame.minY {
            print("Game Over!")
        }
        
        let timeSincePreviousUpdate = currentTime - previousUpdateTime
        playerControlComponent?.update(deltaTime: timeSincePreviousUpdate)
        entityManager.updateShot(timeSincePreviousUpdate)
        previousUpdateTime = currentTime
        updatePositionByPlayerPosition()
        
    }
    
    override func didMove(to view: SKView) {

        // MARK: - Nodes

        configureScoreLabel()
        physicsWorld.contactDelegate = self
        self.entityManager = EntityManager(scene: self)
        entityManager.player = self.player
        self.setupGroundPosition() 
        self.camera = sceneCamera
        self.sceneCamera.position.y = self.size.height / 2
        view.addGestureRecognizer(panGesture)
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Adding Nodes to Scene

    func positionBasedOnLastElement(lastNode: SKSpriteNode,
                                    presentNode: SKSpriteNode,
                                    dx: CGFloat, dy: CGFloat) -> CGPoint {
        let xPositionPlataform = lastNode.position.x + (lastNode.size.width + presentNode.size.width) * 0.5 + dx
        let yPositionPlataform = lastNode.position.y + dy
        
        return CGPoint(x: xPositionPlataform, y: yPositionPlataform)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let entityA = contact.bodyA.node?.entity
        let entityB = contact.bodyB.node?.entity

        print("Colidi")

        if let notifiableEntity = entityA as? ContactNotifiable, let otherEntity = entityB {
            notifiableEntity.contactDidBegin(with: otherEntity, self.entityManager)
        }
        
        if let notifiableEntity = entityB as? ContactNotifiable, let otherEntity = entityA {
            notifiableEntity.contactDidBegin(with: otherEntity, self.entityManager)
        }
    }
}

extension GameScene {
    func configureScoreLabel() {
        heart.position = CGPoint(x: self.frame.minX - 48, y: self.frame.maxY - 48)
        heart.size = CGSize(width: 64, height: 64)
        scoreLabel.position = CGPoint(x: heart.position.x + heart.frame.width / 2 + 10 + scoreLabel.frame.width / 2, y: heart.position.y - scoreLabel.frame.height / 2)
        addChild(heart)
        addChild(scoreLabel)
    }
    
    func updatePositionByPlayerPosition() {
        let playerX = player.component(ofType: AnimatedSpriteComponent.self)!.spriteNode.position.x
        let dx = playerX - lastXPlayerPosition
        lastXPlayerPosition = playerX
        heart.position.x += dx
        scoreLabel.position.x += dx
    }
}
