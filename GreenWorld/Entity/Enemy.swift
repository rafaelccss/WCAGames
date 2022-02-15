import SpriteKit
import GameplayKit

class Enemy: GKEntity {
    
    var life = 100
    var timeSincePreviousUpdate:TimeInterval = TimeInterval()
    var entityManager:EntityManager!
    var maxRangeWalk:CGFloat = 0
    var minRangeWalk:CGFloat = 0
    var enemyType:EnemyType!
    
    init(manager entityManager:EntityManager,type:EnemyType) {
        self.entityManager = entityManager
        self.enemyType = type
        switch(type){
        case .Madeireiro,.Garimpeiro:
            self.life = 100
        case .Boss:
            self.life = 500
        }
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
        
        self.addComponent(WalkComponent(velocity: 2))
        guard let walkComponent = self.component(ofType: WalkComponent.self) else {return}
        walkComponent.direction = .left
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addPhysics(_ node: SKSpriteNode) {
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 100))
        node.physicsBody?.categoryBitMask = CollisionType.enemy.rawValue
        node.physicsBody?.contactTestBitMask = CollisionType.enemy.rawValue | CollisionType.playerWeapon.rawValue | CollisionType.ground.rawValue
        node.physicsBody?.collisionBitMask = CollisionType.ground.rawValue | CollisionType.player.rawValue
        node.physicsBody?.isDynamic = true
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        var isOnScreen:Bool = false
        var shouldShoot = false
        //var changedDirection = false
        guard let playerNode = entityManager.player.component(ofType: AnimatedSpriteComponent.self)?.spriteNode else {return}
        guard let enemyNode = self.component(ofType: AnimatedSpriteComponent.self)?.spriteNode else {return}
        if((entityManager.scene.camera?.contains(enemyNode)) != nil){
            isOnScreen = true
        }
        guard let walkComponent = self.component(ofType: WalkComponent.self) else {return}
        if self.enemyType != EnemyType.Boss{
            walkComponent.update(deltaTime: seconds)
        }
        if(isOnScreen){
            if(enemyNode.xScale == -1 && playerNode.position.x < enemyNode.position.x){
                shouldShoot = true
            }
            else if (enemyNode.xScale == 1 && playerNode.position.x > enemyNode.position.x ){
                shouldShoot = true
            }
            if timeSincePreviousUpdate - seconds >= 3 && shouldShoot{
                let shoot = Int.random(in: 1...10)
                if shoot >= 5 { return }
                if let _ = enemyNode.scene{
                    let direction:MoveDirection = enemyNode.xScale == 1 ? .right : .left
                    let enemyShot = EnemyShotEntity(enemy: self, manager: self.entityManager, direction: direction)
                    entityManager.addShot(enemyShot)
                    timeSincePreviousUpdate = 0
                }
            }
            else{
                timeSincePreviousUpdate += seconds
            }
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
        if entity is Plataform{
            guard let walkComponent = self.component(ofType: WalkComponent.self) else {return}
            switch walkComponent.direction{
            case .right:
                walkComponent.direction = .left
            case .left:
                walkComponent.direction = .right
            default:
                walkComponent.direction = .none
            }
        }
    }
}
