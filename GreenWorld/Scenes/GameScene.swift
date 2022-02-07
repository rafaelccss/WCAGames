import SpriteKit
import GameplayKit

class GameScene: SKScene,SKPhysicsContactDelegate {

    // MARK: - Entities

    let player = Player()
    var entityManager: EntityManager!

    private var previousUpdateTime: TimeInterval = TimeInterval()
    var playerControlComponent: PlayerControlComponent? {
        player.component(ofType: PlayerControlComponent.self)
    }
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
    func attack(){
        entityManager.playerAttack()
    }

    override func update(_ currentTime: TimeInterval) {

        let timeSincePreviousUpdate = currentTime - previousUpdateTime
        playerControlComponent?.update(deltaTime: timeSincePreviousUpdate)
        entityManager.updateShot(timeSincePreviousUpdate)
        previousUpdateTime = currentTime
    }

    override func didMove(to view: SKView) {
        // MARK: - Nodes
        physicsWorld.contactDelegate = self
        self.entityManager = EntityManager(scene: self)
        entityManager.player = self.player
//        self.setupNodesPosition()
        self.setupGroundPosition()
        view.addGestureRecognizer(panGesture)
        view.addGestureRecognizer(tapGesture)
    }

    // MARK: - Adding Nodes to Scene

    func setupNodesPosition() {

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
    func setupGroundPosition() {
        let groundOne = Ground(size: CGSize(width: 500, height: 10))
        let groundTwo = Ground(size: CGSize(width: 300, height: 10))
        let groundThree = Ground(size: CGSize(width: 600, height: 10))
        let groundFour = Ground(size: CGSize(width: 500, height: 10))

        let platarformOne = Plataform()
        let platarformTwo = Plataform()
        let platarformThree = Plataform()
        let platarformFour = Plataform()

        guard let groundComponentOne = groundOne.component(ofType: GroundComponent.self)?.groundNode,
              let groundComponentTwo = groundTwo.component(ofType: GroundComponent.self)?.groundNode,
              let groundComponentThree = groundThree.component(ofType: GroundComponent.self)?.groundNode,
              let groundComponentFour = groundFour.component(ofType: GroundComponent.self)?.groundNode,

              let plataformComponentOne = platarformOne.component(ofType: PlataformComponent.self)?.plataformNode,
              let plataformComponentTwo = platarformTwo.component(ofType: PlataformComponent.self)?.plataformNode,
              let plataformComponentThree = platarformThree.component(ofType: PlataformComponent.self)?.plataformNode,
              let plataformComponentFour = platarformFour.component(ofType: PlataformComponent.self)?.plataformNode,

              let playerNode = player.component(ofType: AnimatedSpriteComponent.self)?.spriteNode else { return }

        groundComponentOne.position = CGPoint(x: scene!.frame.minX + groundComponentOne.size.width/2, y: 50)
        plataformComponentOne.position = positionBasedOnLastElement(lastNode: groundComponentOne,
                                                                    presentNode: plataformComponentOne,
                                                                    dx: 0,
                                                                    dy: 80)
        groundComponentTwo.position = positionBasedOnLastElement(lastNode: plataformComponentOne,
                                                                 presentNode: groundComponentTwo,
                                                                 dx: 0,
                                                                 dy: -80)
        plataformComponentTwo.position = positionBasedOnLastElement(lastNode: groundComponentTwo,
                                                                    presentNode: plataformComponentTwo,
                                                                    dx: 0,
                                                                    dy: 80)
        groundComponentThree.position = positionBasedOnLastElement(lastNode: plataformComponentTwo,
                                                                    presentNode: groundComponentThree,
                                                                    dx: 0,
                                                                    dy: -80)
        plataformComponentThree.position = positionBasedOnLastElement(lastNode: groundComponentThree,
                                                                    presentNode: plataformComponentThree,
                                                                    dx: 0,
                                                                    dy: 80)
        groundComponentFour.position = positionBasedOnLastElement(lastNode: plataformComponentThree,
                                                                    presentNode: groundComponentFour,
                                                                    dx: 0,
                                                                    dy: -80)
        plataformComponentFour.position = positionBasedOnLastElement(lastNode: groundComponentFour,
                                                                      presentNode: plataformComponentFour,
                                                                      dx: 0,
                                                                      dy: 80)

        playerNode.position = positionBasedOnLastElement(lastNode: groundComponentOne,
                                                         presentNode: playerNode,
                                                         dx: -200,
                                                         dy: 45 + groundComponentOne.size.height/2)

        self.addChild(groundComponentOne)
        self.addChild(groundComponentTwo)
        self.addChild(groundComponentThree)
        self.addChild(groundComponentFour)
        self.addChild(plataformComponentOne)
        self.addChild(plataformComponentTwo)
        self.addChild(plataformComponentThree)
        self.addChild(plataformComponentFour)
        self.addChild(playerNode)
    }
}
