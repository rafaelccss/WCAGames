import GameplayKit

class Plataform: GKEntity {

    override init() {
        super.init()
        let plataformComponent = PlataformComponent(imageName: "Plataform_\(Int.random(in: 0...1))")
        plataformComponent.plataformNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 200, height: 40))
        plataformComponent.plataformNode.physicsBody?.isDynamic = false
        plataformComponent.plataformNode.physicsBody?.categoryBitMask = CollisionType.ground.rawValue
        plataformComponent.plataformNode.physicsBody?.contactTestBitMask = CollisionType.playerWeapon.rawValue | CollisionType.enemy.rawValue
        plataformComponent.plataformNode.physicsBody?.collisionBitMask = CollisionType.playerWeapon.rawValue
        self.addComponent(plataformComponent)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Plataform:ContactNotifiable{
    func contactDidBegin(with entity: GKEntity, _ manager: EntityManager) {
    }
}
