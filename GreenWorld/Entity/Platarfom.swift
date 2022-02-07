import GameplayKit

class Plataform: GKEntity {

    override init() {
        super.init()
        let plataformComponent = PlataformComponent()
        plataformComponent.plataformNode.physicsBody = SKPhysicsBody(rectangleOf: plataformComponent.plataformNode.size)
        plataformComponent.plataformNode.physicsBody?.isDynamic = false
        plataformComponent.plataformNode.physicsBody?.categoryBitMask = CollisionType.ground.rawValue
        plataformComponent.plataformNode.physicsBody?.contactTestBitMask = CollisionType.ground.rawValue
        self.addComponent(plataformComponent)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
