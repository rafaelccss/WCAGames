import GameplayKit

class Ground: GKEntity {

    init(size: CGSize) {
        super.init()
        let groundComponent = GroundComponent(size: size)
        self.addComponent(groundComponent)
        groundComponent.groundNode.physicsBody = SKPhysicsBody(rectangleOf: size)
        groundComponent.groundNode.physicsBody?.isDynamic = false
        groundComponent.groundNode.physicsBody?.categoryBitMask = CollisionType.ground.rawValue
        groundComponent.groundNode.physicsBody?.contactTestBitMask = CollisionType.ground.rawValue | CollisionType.player.rawValue
        groundComponent.groundNode.physicsBody?.collisionBitMask = CollisionType.player.rawValue | CollisionType.Enemy.rawValue
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension Ground:ContactNotifiable{
    func contactDidBegin(with entity: GKEntity, _ manager: EntityManager) {
    }
}
