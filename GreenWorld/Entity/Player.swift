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
        node.physicsBody?.contactTestBitMask = CollisionType.player.rawValue | CollisionType.ground.rawValue | CollisionType.coin.rawValue
        node.physicsBody?.collisionBitMask = CollisionType.ground.rawValue | CollisionType.enemy.rawValue
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.isDynamic = true
    }
}

extension Player:ContactNotifiable{
    func contactDidBegin(with entity: GKEntity, _ manager: EntityManager) {
       /* if entity is ShotEntity{
            guard let shotComponent = entity.component(ofType: ShotComponent.self) else {return}
            self.life -= shotComponent.damage
            self.life = self.life < 0 ? 0 : self.life
        }*/
        if (entity is Ground || entity is Plataform){
            guard let playerControlComponent = self.component(ofType: PlayerControlComponent.self) else {return}
            playerControlComponent.stateMachine.enterTo(IdleState.self)
        }
        if entity is EnemyShotEntity{
            guard let shotComponent = entity.component(ofType: EnemyShotComponent.self) else {return}
            self.life -= shotComponent.damage
            if(life<=0){
                manager.removePlayer()
            }
        }
    }
}
