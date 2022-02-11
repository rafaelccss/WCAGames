import SpriteKit
import GameplayKit

class Player: GKEntity {
    
    var life: Int {
        willSet {
            delegate?.didUpdateLife(newValue)
        }
    }
    var delegate: LifeManager?
    

    override init() {
        self.life = 100
        super.init()
        let spriteComponent = AnimatedSpriteComponent(atlasName: "")
        addPhysics(node: spriteComponent.spriteNode)
        self.addComponent(spriteComponent)
        
        self.addComponent(
            PlayerControlComponent(states: [
                IdleState(self),
                AttackState(self),
                JumpState(self),
                LeftWalkState(self),
                RightWalkState(self),
                LeftJumpState(self),
                RightJumpState(self)
            ])
        )
        
        self.addComponent(WalkComponent(velocity: 1))
        self.addComponent(JumpComponent(impulse: 600))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addPhysics(node: SKSpriteNode) {
        //node.physicsBody = SKPhysicsBody(texture: node.texture!, size: node.texture!.size())
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 90))
        node.physicsBody?.categoryBitMask = CollisionType.player.rawValue
        node.physicsBody?.contactTestBitMask = CollisionType.coin.rawValue
        node.physicsBody?.collisionBitMask = CollisionType.ground.rawValue | CollisionType.enemy.rawValue | CollisionType.enemyWeapon.rawValue
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.isDynamic = true
     }
}

extension Player:ContactNotifiable{
    func contactDidBegin(with entity: GKEntity, _ manager: EntityManager) {
        if entity is ShotEntity{
            guard let shotComponent = entity.component(ofType: ShotComponent.self) else {return}
            self.life -= shotComponent.damage
            self.life = self.life < 0 ? 0 : self.life
        }
    }
}
