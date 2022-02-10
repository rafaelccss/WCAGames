import UIKit
import GameplayKit
import SpriteKit

class ShotEntity: GKEntity {
    var direction : MoveDirection
    init(entityManager:EntityManager,power:Powers,direction directionShot:MoveDirection) {
        self.direction = directionShot
        super.init()
        var nameTexture: String
        switch power {
            case .Tupã:
                nameTexture = "TupãShot"
                break
            case .Guaraci:
                nameTexture = "GuaraciShot"
                break
            default:
                nameTexture = "NormalShot"
        }
        let texture = SKTexture(imageNamed: nameTexture)
        let spriteComponent = AnimatedSpriteComponent(atlasName: "")
        addComponent(spriteComponent)
        let player = entityManager.getPlayer()
        guard let playerNode = player.component(ofType: AnimatedSpriteComponent.self)?.spriteNode else {return}
        spriteComponent.spriteNode.physicsBody = SKPhysicsBody(rectangleOf: spriteComponent.spriteNode.size)
        spriteComponent.spriteNode.position = CGPoint(x: playerNode.position.x + 10, y: playerNode.position.y + 20)
        spriteComponent.spriteNode.physicsBody?.categoryBitMask = CollisionType.playerWeapon.rawValue
        spriteComponent.spriteNode.physicsBody?.contactTestBitMask = CollisionType.enemy.rawValue | CollisionType.ground.rawValue
        spriteComponent.spriteNode.physicsBody?.collisionBitMask = CollisionType.ground.rawValue
        spriteComponent.spriteNode.physicsBody?.affectedByGravity = false
        let moveComponent = WalkComponent(velocity: 10)
        moveComponent.direction = directionShot
        addComponent(moveComponent)
        addComponent(ShotComponent(power, entityManager))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ShotEntity:ContactNotifiable{
    func contactDidBegin(with entity: GKEntity,_ manager:EntityManager) {
        manager.removeShot(self)
    }
}
