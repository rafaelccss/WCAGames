import GameplayKit

class Ground: GKEntity {

    init(size: CGSize) {
        super.init()
        let groundComponent = GroundComponent(size: size)
        groundComponent.groundNode.physicsBody = SKPhysicsBody()
        groundComponent.groundNode.physicsBody?.categoryBitMask = CollisionType.playerWeapon.rawValue
        groundComponent.groundNode.physicsBody?.contactTestBitMask = CollisionType.Enemy.rawValue
        self.addComponent(groundComponent)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
