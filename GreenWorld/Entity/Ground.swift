import GameplayKit

class Ground: GKEntity {

    init(size: CGSize) {
        super.init()
        let groundComponent = GroundComponent(size: size)
        self.addComponent(groundComponent)
        groundComponent.groundNode.physicsBody = SKPhysicsBody(rectangleOf: size)
        groundComponent.groundNode.physicsBody?.isDynamic = true
        groundComponent.groundNode.physicsBody?.allowsRotation = false
        groundComponent.groundNode.physicsBody?.friction = 0.04
        groundComponent.groundNode.physicsBody?.pinned = true
        groundComponent.groundNode.physicsBody?.categoryBitMask = CollisionType.ground.rawValue
        groundComponent.groundNode.physicsBody?.contactTestBitMask = CollisionType.ground.rawValue | CollisionType.player.rawValue
        groundComponent.groundNode.physicsBody?.collisionBitMask = CollisionType.player.rawValue | CollisionType.enemy.rawValue
        self.addComponent(groundComponent)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Ground:ContactNotifiable {
    
    func contactDidBegin(with entity: GKEntity, _ manager: EntityManager) {
    }
}
