//
//  ShootingComponent.swift
//  GreenWorld
//
//  Created by Nathan Batista de Oliveira on 04/02/22.
//

import UIKit
import GameplayKit
import SpriteKit


class ShotComponent: GKComponent {
    var damage = 50
    var velocity = 10
    var entityManager: EntityManager
    
    init(_ power:Powers,x positionX:Int,y positionY:Int, _ entityManager:EntityManager){
        switch power{
            case .Tupã,.Guaraci:
                self.damage = 100
                break
            default:
                self.damage = 50
        }
        self.entityManager = entityManager
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
