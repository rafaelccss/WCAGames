import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: - Entities
    
    let player = Player()
    var entityManager: EntityManager!
    var isGameOver = false
    var isCreated = false
    var count = 0
    var handle: HandleWithScenes?
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
    
    let lifeLabel = SKLabelNode(text: "100")
    let heart = SKSpriteNode(imageNamed: "FullHeart")
    
    let coinNode = SKSpriteNode(imageNamed: "Coin")
    let coinsCount = SKLabelNode(text: "000")
    
    override func update(_ currentTime: TimeInterval) {
        self.sceneCamera.position.x = player.component(ofType: AnimatedSpriteComponent.self)!.spriteNode.position.x
        if player.component(ofType: AnimatedSpriteComponent.self)!.spriteNode.position.y < self.frame.minY && !isGameOver {
            player.life = 0
            player.component(ofType: AnimatedSpriteComponent.self)!.spriteNode.removeFromParent()
            handle?.quitGame()
        }
        
        let timeSincePreviousUpdate = currentTime - previousUpdateTime
        playerControlComponent?.update(deltaTime: timeSincePreviousUpdate)
        entityManager.updateShot(timeSincePreviousUpdate)
        self.entityManager.updateEnemy(timeSincePreviousUpdate)
        previousUpdateTime = currentTime
        entityManager.updatePositionByPlayerPosition()
        entityManager.updateEnemy(timeSincePreviousUpdate)
        
    }
    
    override func didMove(to view: SKView) {
        
        // MARK: - Nodes
        if !isCreated {
            self.entityManager = EntityManager(scene: self)
            entityManager.player = self.player
            entityManager.configureScoreLabel()
            physicsWorld.contactDelegate = self
            self.player.delegate = self
            self.entityManager.addGrounds()
            //self.enemy = Enemy(manager: self.entityManager)
            self.setupCoins()
            entityManager.setupEnemy()
            self.camera = sceneCamera
            self.sceneCamera.position.y = self.size.height / 2
            entityManager.setupInvisibleGround()
            view.addGestureRecognizer(panGesture)
            view.addGestureRecognizer(tapGesture)
            view.isMultipleTouchEnabled = true
            isCreated = true
        }
    }
    
    func setupCoins(){
        let platforms = entityManager.platforms
        for platform in platforms {
            let plataformNode = platform.component(ofType: PlataformComponent.self)?.plataformNode
            let coin = Coin()
            coin.component(ofType: AnimatedSpriteComponent.self)?.spriteNode.position = positionBasedOnLastElement(lastNode: plataformNode!,
                                                                                                                   presentNode: coin.component(ofType: AnimatedSpriteComponent.self)!.spriteNode,
                                                                                                                   dx: -(plataformNode?.size.width)!/2,
                                                                                                                   dy: (plataformNode?.size.height)! + 30)
            coin.delegate = self
            entityManager.addCoin(coin)
            
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let entityA = contact.bodyA.node?.entity
        let entityB = contact.bodyB.node?.entity
        
        if let notifiableEntity = entityA as? ContactNotifiable, let otherEntity = entityB {
            notifiableEntity.contactDidBegin(with: otherEntity, self.entityManager)
        }
        
        if let notifiableEntity = entityB as? ContactNotifiable, let otherEntity = entityA {
            notifiableEntity.contactDidBegin(with: otherEntity, self.entityManager)
        }
    }
}

extension GameScene {
    // MARK: - Adding Nodes to Scene
    func positionBasedOnLastElement(lastNode: SKSpriteNode,
                                    presentNode: SKSpriteNode,
                                    dx: CGFloat, dy: CGFloat) -> CGPoint {
        let xPositionPlataform = lastNode.position.x + (lastNode.size.width + presentNode.size.width) * 0.5 + dx
        let yPositionPlataform = lastNode.position.y + dy
        
        return CGPoint(x: xPositionPlataform, y: yPositionPlataform)
    }
    
    @objc func walk(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            playerControlComponent?.handle(direction: sender.direction)
            
        case .ended:
            playerControlComponent?.halt()
            
        default:
            break
        }
    }
    
    @objc func attack(){
        entityManager.playerAttack()
    }
}


extension GameScene: LifeManager {
    
    func didUpdateLife(_ life: Int) {
        entityManager.didUpdateLife(life)
    }
}

extension GameScene : CollecteddCoinDelegate{
    func collected(_ coin: Coin) {
        entityManager.coins.removeAll { $0 == coin }
        count += 1
        if count == 1 {
            handle?.callOptionScene()
        }
        coinsCount.text = String.init(format: "%03d", count)
    }
}
