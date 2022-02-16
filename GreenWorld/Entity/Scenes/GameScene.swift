import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: - Entities
    
    let player = Player()
    var entityManager: EntityManager!
    var background = SKSpriteNode(imageNamed: "Background")
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
    let colorFactor = 0.8
    
    // MARK: - Gestures
    
    lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(attack))
    lazy var panGesture = UIPanGestureRecognizer(target: self, action: #selector(walk))
    

    let lifeLabel = SKLabelNode(text: "100")
    let heart = SKSpriteNode(imageNamed: "FullHeart")
    let featherNode = SKSpriteNode(imageNamed: "Feather_0")
    let featherCount = SKLabelNode(text: "000")

    override func update(_ currentTime: TimeInterval) {
        self.sceneCamera.position.x = player.component(ofType: AnimatedSpriteComponent.self)!.spriteNode.position.x
        if player.component(ofType: AnimatedSpriteComponent.self)!.spriteNode.position.y < self.frame.minY && !isGameOver {
            player.life = 0
            entityManager.removePlayer()
            handle?.callOptionScene()
        }
        
        let timeSincePreviousUpdate = currentTime - previousUpdateTime
        playerControlComponent?.update(deltaTime: timeSincePreviousUpdate)
        entityManager.updateShot(timeSincePreviousUpdate)
        self.entityManager.updateEnemy(timeSincePreviousUpdate)
        previousUpdateTime = currentTime
        entityManager.updatePositionByPlayerPosition()
        entityManager.updateEnemy(timeSincePreviousUpdate)
        if let xPlayer = entityManager.player.component(ofType: AnimatedSpriteComponent.self)?.spriteNode.position.x {
            background.position.x = xPlayer
        }
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
            setupFeathers()
            entityManager.setupEnemy()
            entityManager.healDelegate = self
            self.camera = sceneCamera
            self.sceneCamera.position.y = self.size.height / 2
            entityManager.setupInvisibleGround()
            view.addGestureRecognizer(panGesture)
            view.addGestureRecognizer(tapGesture)
            view.isMultipleTouchEnabled = true
            isCreated = true
            background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
            background.size = self.size
            background.xScale = 1.2
            background.color = .red
            background.colorBlendFactor = colorFactor
            background.zPosition = -10
            addChild(background)
        }
    }
    
    func setupFeathers() {
        let platforms = entityManager.platforms
        for platform in platforms {
            let plataformNode = platform.component(ofType: PlataformComponent.self)?.plataformNode

            let feather = Feather()
            feather.component(ofType: AnimatedSpriteComponent.self)?.spriteNode.position = CGPoint(x: plataformNode!.frame.midX, y: plataformNode!.frame.maxY + 32)
            feather.delegate = self
            entityManager.addFeather(feather)
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
    
    func restartPlayer() {
        entityManager.revivePlayer()
    }
    
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
    
    func restartGame() {
        entityManager.revivePlayer()
        self.isGameOver = false
    }
}


extension GameScene: LifeManager {
    
    func didUpdateLife(_ life: Int) {
        entityManager.didUpdateLife(life)
    }
}

extension GameScene : CollecteddFeatherDelegate {

    func collected(_ feather: Feather) {

        entityManager.feathers.removeAll { $0 == feather }
        count += 1

        entityManager.feathersCount.text = String.init(format: "%03d", count)
        if count == 3 {
            handle?.callPowerScene()
        }
    }
}

extension GameScene: HealWorldDelegate {
    func enemyDefeated(enemiesDefeated: CGFloat, totalEnemies: CGFloat) {
        background.colorBlendFactor = colorFactor - colorFactor * enemiesDefeated / totalEnemies
    }
}
