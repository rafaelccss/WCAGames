import Foundation
import GameplayKit
import SpriteKit

class EnemyShotEntity : GKEntity {

    var damage:Int = 25
    var direction:MoveDirection
    init(enemy enemyEntity : Enemy, manager entityManager: EntityManager, direction directionShot: MoveDirection) {

        /*switch enemy{
        case .Boss:
            self.life = 200
        default:
            self.life = 100
        }*/
        self.damage = enemyEntity.enemyType == .Boss ? 50 : 25
        self.direction = directionShot

        let spriteComponent = AnimatedSpriteComponent(imageName: enemyEntity.enemyType == EnemyType.Boss ? "Wood" : "Axe", size: CGSize(width: 56, height: 56))
        spriteComponent.spriteNode.run(.repeatForever(.rotate(byAngle: .pi * 2, duration: 1)))
        
        super.init()
        self.addComponent(spriteComponent)
        guard let enemyNode = enemyEntity.component(ofType: AnimatedSpriteComponent.self)?.spriteNode else { return }
        spriteComponent.spriteNode.physicsBody = SKPhysicsBody(rectangleOf: spriteComponent.spriteNode.size)
        spriteComponent.spriteNode.position = CGPoint(x: enemyNode.position.x + 10, y: enemyNode.position.y + 20)
        spriteComponent.spriteNode.physicsBody?.categoryBitMask = CollisionType.enemyWeapon.rawValue
        spriteComponent.spriteNode.physicsBody?.contactTestBitMask = CollisionType.player.rawValue | CollisionType.ground.rawValue
        spriteComponent.spriteNode.physicsBody?.collisionBitMask = CollisionType.ground.rawValue
        spriteComponent.spriteNode.physicsBody?.affectedByGravity = false
        let moveComponent = WalkComponent(velocity: 1.2)
        moveComponent.direction = directionShot
        addComponent(moveComponent)
        addComponent(EnemyShotComponent(enemy: enemyEntity, manager: entityManager))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EnemyShotEntity: ContactNotifiable {

    func contactDidBegin(with entity: GKEntity, _ manager: EntityManager) {
        manager.removeShot(self)
    }
}
