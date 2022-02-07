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
        
        let spriteComponent = AnimatedSpriteComponent(atlasName: "")
        addPhysics(spriteComponent.spriteNode)
        self.addComponent(spriteComponent)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addPhysics(_ node: SKSpriteNode) {
        node.physicsBody = SKPhysicsBody()
        node.physicsBody?.categoryBitMask = CollisionType.Enemy.rawValue
        node.physicsBody?.collisionBitMask = CollisionType.ground.rawValue | CollisionType.player.rawValue | CollisionType.playerWeapon.rawValue
        node.physicsBody?.isDynamic = true
    }
}
