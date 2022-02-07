import UIKit
import GameplayKit
import SpriteKit

class ShotEntity: GKEntity {
    var direction : MoveDirection
    init(entityManager:EntityManager,power:Powers,direction directionShot:MoveDirection){
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
        let player = entityManager.getPlayer()
        spriteComponent.spriteNode.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        spriteComponent.spriteNode.physicsBody?.categoryBitMask = CollisionType.playerWeapon.rawValue
        spriteComponent.spriteNode.physicsBody?.contactTestBitMask = CollisionType.Enemy.rawValue | CollisionType.ground.rawValue
        spriteComponent.spriteNode.physicsBody?.collisionBitMask = CollisionType.Enemy.rawValue | CollisionType.ground.rawValue
        let moveComponent = WalkComponent(velocity: 10)
        moveComponent.direction = directionShot
        addComponent(moveComponent)
        addComponent(spriteComponent)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ShotEntity:ContactNotifiable{
    func contactDidBegin(with entity: GKEntity,_ manager:EntityManager) {
        manager.remove(self)
    }
}
