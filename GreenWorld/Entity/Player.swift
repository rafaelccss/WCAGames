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

        let spriteComponent = AnimatedSpriteComponent(imageName: "Idle_0")
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
        
        self.addComponent(WalkComponent(velocity: 1))
        self.addComponent(JumpComponent(impulse: 50))

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addPhysics(node: SKSpriteNode) {

		if let texture = node.texture {

			node.physicsBody = SKPhysicsBody(texture: texture, size: CGSize(width: 50, height: 90))

		} else {

			node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 90))
		}
        node.physicsBody?.categoryBitMask = CollisionType.player.rawValue
        node.physicsBody?.contactTestBitMask = CollisionType.player.rawValue | CollisionType.feather.rawValue | CollisionType.enemyWeapon.rawValue | CollisionType.ground.rawValue
        node.physicsBody?.collisionBitMask = CollisionType.ground.rawValue | CollisionType.enemy.rawValue
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.isDynamic = true
        node.physicsBody?.friction = 0.2
        node.physicsBody?.mass = 0.08
    }
}

extension Player: ContactNotifiable {

    func contactDidBegin(with entity: GKEntity, _ manager: EntityManager) {

        if (entity is Ground || entity is Plataform) {

            guard let playerControlComponent = self.component(ofType: PlayerControlComponent.self) else {return}
            if playerControlComponent.stateMachine.currentState?.classForCoder === JumpState.self {
                playerControlComponent.stateMachine.enterTo(IdleState.self)
            }
        }

        if entity is EnemyShotEntity {

            guard let shotComponent = entity.component(ofType: EnemyShotComponent.self) else { return }
            self.life -= shotComponent.damage
            if(life <= 0) {
                manager.removePlayer()
            }
        }
    }
}
