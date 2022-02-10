//
//  Enemy.swift
//  GreenWorld
//
//  Created by Luís Filipe Nascimento on 07/02/22.
//

import SpriteKit
import GameplayKit

class Enemy: GKEntity {
    
    var life = 100
    
    override init() {
        super.init()
        
        //let spriteComponent = AnimatedSpriteComponent(atlasName: "")
        let spriteComponent = AnimatedSpriteComponent(color: .blue, size: CGSize(width: 100, height: 100))
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
        node.physicsBody?.categoryBitMask = CollisionType.Enemy.rawValue
        node.physicsBody?.contactTestBitMask = CollisionType.Enemy.rawValue | CollisionType.playerWeapon.rawValue
        node.physicsBody?.collisionBitMask = CollisionType.ground.rawValue | CollisionType.player.rawValue
        node.physicsBody?.isDynamic = true
    }
}

extension Enemy: ContactNotifiable {
    func contactDidBegin(with entity: GKEntity, _ manager: EntityManager) {
        if entity is ShotEntity{
            guard let shotComponent = entity.component(ofType: ShotComponent.self) else {return}
            self.life -= shotComponent.damage
            if self.life <= 0{
                manager.remove(self)
            }
        }
    }
}
