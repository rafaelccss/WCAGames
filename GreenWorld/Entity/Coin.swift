//
//  Coin.swift
//  GreenWorld
//
//  Created by Luís Filipe Nascimento on 09/02/22.
//

import UIKit
import GameplayKit

protocol CollecteddCoinDelegate {
    func collected(_ coin: Coin)
}

class Coin: GKEntity {
    
    var delegate: CollecteddCoinDelegate?
    
    override init() {
        super.init()
        
        let coinNode = SKSpriteNode(imageNamed: "Coin")
        coinNode.size = CGSize(width: 32, height: 32)
        addPhysics(coinNode)
        
        self.addComponent(AnimatedSpriteComponent(spriteNode: coinNode))
        let rotation = RotationYComponent()
        self.addComponent(rotation)
        rotation.rotateForever()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addPhysics(_ node: SKSpriteNode) {
        node.physicsBody = SKPhysicsBody(texture: node.texture!, size: node.size)
        node.physicsBody?.categoryBitMask = CollisionType.coin.rawValue
        node.physicsBody?.contactTestBitMask = CollisionType.player.rawValue
       // node.physicsBody?.collisionBitMask = CollisionType.player.rawValue
        node.physicsBody?.isDynamic = false
    }
}

extension Coin: ContactNotifiable {
    func contactDidBegin(with entity: GKEntity, _ manager: EntityManager) {
        if entity is Player {
            delegate?.collected(self)
            self.component(ofType: AnimatedSpriteComponent.self)!.spriteNode.removeFromParent()
        }
    }
}
