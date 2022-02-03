//
//  ShotEntity.swift
//  GreenWorld
//
//  Created by Nathan Batista de Oliveira on 03/02/22.
//

import UIKit
import GameplayKit
import SpriteKit

class ShotEntity: GKEntity {
    init(entityManager:EntityManager,power:Powers){
        super.init()
        var nameTexture:String
        switch power{
            case .Tupã:
                nameTexture = "TupãShot"
                break
            case .Guaraci:
                nameTexture = "GuaraciShot"
                break
            default:
                nameTexture = "NormalShot"
        }
        let texture = SKTexture(imageNamed:nameTexture)
        let spriteComponent = SpriteComponent(entity:self,texture:texture,size: texture.size())
        spriteComponent.node.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        spriteComponent.node.physicsBody?.categoryBitMask = CollisionType.playerWeapon.rawValue
        spriteComponent.node.physicsBody?.contactTestBitMask = CollisionType.Enemy.rawValue
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
