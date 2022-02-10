//
//  RotationYComponent.swift
//  GreenWorld
//
//  Created by Luís Filipe Nascimento on 09/02/22.
//

import UIKit
import GameplayKit

class RotationYComponent: GKComponent {
    var spriteNode: SKSpriteNode? {
        self.entity?.component(ofType: AnimatedSpriteComponent.self)?.spriteNode
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func rotateForever() {
        self.spriteNode?.run(
            .repeatForever(
                SKAction.sequence(
                    [
                        SKAction.scaleX(to: -1, duration: 0.5),
                        SKAction.scaleX(to: 1, duration: 0.5)
                    ]
                )
            )
        )
    }
}
