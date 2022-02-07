import SpriteKit
import GameplayKit

class Player: GKEntity {
    
    var life: Int = 100
    

    override init() {
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
                RightWalkState(self)
            ])
        )
        
        self.addComponent(WalkComponent())
        self.addComponent(JumpComponent(impulse: 600))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addPhysics(node: SKSpriteNode) {
        //node.physicsBody = SKPhysicsBody(texture: node.texture!, size: node.texture!.size())
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 90))
        node.physicsBody?.categoryBitMask = CollisionType.player.rawValue
        node.physicsBody?.contactTestBitMask = CollisionType.player.rawValue
        node.physicsBody?.collisionBitMask = CollisionType.ground.rawValue | CollisionType.Enemy.rawValue | CollisionType.enemyWeapon.rawValue
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.isDynamic = true
    }
}
