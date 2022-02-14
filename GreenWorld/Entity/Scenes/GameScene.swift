import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: - Entities
    
    let player = Player()
    var entityManager: EntityManager!
    var enemy: Enemy!
    //var lastXPlayerPosition:CGFloat = 0
    //var coins = [Coin]()
    var isGameOver = false

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
    func attack() {
        entityManager.playerAttack()
    }

    override func update(_ currentTime: TimeInterval) {
        self.sceneCamera.position.x = player.component(ofType: AnimatedSpriteComponent.self)!.spriteNode.position.x
        if player.component(ofType: AnimatedSpriteComponent.self)!.spriteNode.position.y < self.frame.minY && !isGameOver{
            player.life = 0
            player.component(ofType: AnimatedSpriteComponent.self)!.spriteNode.removeFromParent()
        }
        
        let timeSincePreviousUpdate = currentTime - previousUpdateTime
        playerControlComponent?.update(deltaTime: timeSincePreviousUpdate)
        entityManager.updateShot(timeSincePreviousUpdate)
        self.entityManager.updateEnemy(timeSincePreviousUpdate)
        previousUpdateTime = currentTime
        entityManager.updatePositionByPlayerPosition()
        
    }
    
    override func didMove(to view: SKView) {

        // MARK: - Nodes
        self.entityManager = EntityManager(scene: self)
        entityManager.player = self.player
        entityManager.configureScoreLabel()
        physicsWorld.contactDelegate = self
        self.player.delegate = self
        self.entityManager.addGrounds()
        self.enemy = Enemy(manager: self.entityManager)
        entityManager.setupCoins()
        entityManager.setupEnemy()
        self.camera = sceneCamera
        self.sceneCamera.position.y = self.size.height / 2
        view.addGestureRecognizer(panGesture)
        view.addGestureRecognizer(tapGesture)
        view.isMultipleTouchEnabled = true
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

    /*func configureScoreLabel() {
        let xPlayerPosition = player.component(ofType: AnimatedSpriteComponent.self)!.spriteNode.position.x
        heart.position = CGPoint(x: xPlayerPosition - self.view!.frame.width / 2 + 52, y: self.frame.maxY - 48)
        heart.size = CGSize(width: 48, height: 48)
        coinNode.position = CGPoint(x: heart.position.x + self.view!.frame.width - 112, y: self.frame.maxY - 48)
        coinNode.size = CGSize(width: 32, height: 32)
        lifeLabel.position = CGPoint(x: heart.position.x + heart.frame.width / 2 + 10 + lifeLabel.frame.width / 2, y: heart.position.y - lifeLabel.frame.height / 2)
        coinsCount.position = CGPoint(x: coinNode.position.x - coinNode.frame.width / 2 - 10 - coinsCount.frame.width / 2, y: coinNode.position.y - coinsCount.frame.height / 2)
        addChild(coinNode)
        addChild(coinsCount)
        addChild(heart)
        addChild(lifeLabel)
    }*/
    
    /*func updatePositionByPlayerPosition() {
        let playerX = player.component(ofType: AnimatedSpriteComponent.self)!.spriteNode.position.x
        let dx = playerX - lastXPlayerPosition
        lastXPlayerPosition = playerX
        heart.position.x += dx
        lifeLabel.position.x += dx
        coinsCount.position.x += dx
        coinNode.position.x += dx
    }*/
}

extension GameScene: LifeManager {

    func didUpdateLife(_ life: Int) {
        entityManager.didUpdateLife(life)
    }
}

/*extension GameScene: CollecteddCoinDelegate {
    func collected(_ coin: Coin) {
        self.coins.removeAll { $0 == coin }
        count += 1
        self.coinsCount.text = String.init(format: "%03d", count)
    }
}*/
