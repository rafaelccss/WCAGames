import SpriteKit
import GameplayKit

class Enemy: GKEntity {
    
    var life = 100
    var timeSincePreviousUpdate:TimeInterval = TimeInterval()
    var entityManager:EntityManager!
    
    init(manager entityManager:EntityManager) {
        self.entityManager = entityManager
        super.init()
        
        //let spriteComponent = AnimatedSpriteComponent(atlasName: "")
        let spriteComponent = AnimatedSpriteComponent(color: .blue, size: CGSize(width: 100, height: 100))
        spriteComponent.spriteNode.xScale = -1
        self.addComponent(spriteComponent)
        addPhysics(spriteComponent.spriteNode)
        
        self.addComponent(
            EnemyControlComponent(states:
            [
                AttackState(self),
                LeftWalkState(self),
                RightWalkState(self)
            ])
        )
        
        self.addComponent(WalkComponent())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addPhysics(_ node: SKSpriteNode) {
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 100))
        node.physicsBody?.categoryBitMask = CollisionType.enemy.rawValue
        node.physicsBody?.contactTestBitMask = CollisionType.enemy.rawValue | CollisionType.playerWeapon.rawValue
        node.physicsBody?.collisionBitMask = CollisionType.ground.rawValue | CollisionType.player.rawValue
        node.physicsBody?.isDynamic = true
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if timeSincePreviousUpdate - seconds >= 1{
            guard let enemyNode = self.component(ofType: AnimatedSpriteComponent.self)?.spriteNode else {return}
            let direction:MoveDirection = enemyNode.xScale == 1 ? .right : .left
            let enemyShot = EnemyShotEntity(enemy: self, manager: self.entityManager, direction: direction)
            entityManager.addShot(enemyShot)
            timeSincePreviousUpdate = 0
        }
        else{
            timeSincePreviousUpdate += seconds
        }
    }
}

extension Enemy: ContactNotifiable {
    func contactDidBegin(with entity: GKEntity, _ manager: EntityManager) {
        if entity is ShotEntity {
            guard let shotComponent = entity.component(ofType: ShotComponent.self) else {return}
            self.life -= shotComponent.damage
            if self.life <= 0 {
                manager.remove(self)
            }
        }
    }
}
