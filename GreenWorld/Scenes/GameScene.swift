import SpriteKit
import GameplayKit

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    // MARK: - Entities
    
    let player = Player()
    let ground = Ground(size: CGSize(width: 500, height: 10))
    let platarform = Plataform()
    var entityManager: EntityManager!
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
    // lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(attack))
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
    
    override func update(_ currentTime: TimeInterval) {
        self.sceneCamera.position = player.component(ofType: AnimatedSpriteComponent.self)!.spriteNode.position
        
        let timeSincePreviousUpdate = currentTime - previousUpdateTime
        playerControlComponent?.update(deltaTime: timeSincePreviousUpdate)
        previousUpdateTime = currentTime
    }
    
    override func didMove(to view: SKView) {
        // MARK: - Nodes
        self.entityManager = EntityManager(scene: self)
        self.setupNodesPosition()
        self.camera = sceneCamera
        view.addGestureRecognizer(panGesture)
    }
    
    // MARK: - Adding Nodes to Scene
    
    func setupNodesPosition() {
        guard let groundComponent = ground.component(ofType: GroundComponent.self)?.groundNode,
              let plataformComponent = platarform.component(ofType: PlataformComponent.self)?.plataformNode,
              let playerNode = player.component(ofType: AnimatedSpriteComponent.self)?.spriteNode else { return }
        groundComponent.position = CGPoint(x: scene!.frame.minX + groundComponent.size.width/2, y: 50)
        plataformComponent.position = positionBasedOnLastElement(lastNode: groundComponent,
                                                                 presentNode: plataformComponent,
                                                                 dx: 0,
                                                                 dy: 80)
        playerNode.position = positionBasedOnLastElement(lastNode: groundComponent,
                                                         presentNode: playerNode,
                                                         dx: -300,
                                                         dy: 50 + groundComponent.size.height / 2)
        
        let enemy = Enemy()
        if let enemyNode =  enemy.component(ofType: AnimatedSpriteComponent.self)?.spriteNode {
            enemyNode.position = positionBasedOnLastElement(lastNode: groundComponent, presentNode: enemyNode, dx: -100, dy: enemyNode.size.height + groundComponent.size.height / 2 + 10)
            self.addChild(enemyNode)
        }
        self.addChild(groundComponent)
        self.addChild(plataformComponent)
        self.addChild(playerNode)
    }
    
    
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
        
        if let notifiableEntity = entityA as? ContactNotifiable, let otherEntity = entityB {
            notifiableEntity.contactDidBegin(with: otherEntity, self.entityManager)
        }
        
        if let notifiableEntity = entityB as? ContactNotifiable, let otherEntity = entityA {
            notifiableEntity.contactDidBegin(with: otherEntity, self.entityManager)
        }
    }
}
