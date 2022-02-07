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
        addPhysics(spriteComponent.spriteNode)
        self.addComponent(spriteComponent)
        
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
        node.physicsBody?.contactTestBitMask = CollisionType.Enemy.rawValue
        node.physicsBody?.collisionBitMask = CollisionType.ground.rawValue | CollisionType.player.rawValue | CollisionType.playerWeapon.rawValue
        node.physicsBody?.isDynamic = true
    }
}
