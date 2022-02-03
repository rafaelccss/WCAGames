//
//  SpriteComponent.swift
//  GreenWorld
//
//  Created by Nathan Batista de Oliveira on 02/02/22.
//

import SpriteKit
import GameplayKit

// 2
class SpriteComponent: GKComponent {

  // 3
  let node: SKSpriteNode

  // 4
    init(entity: GKEntity,texture: SKTexture,size: CGSize) {
        node = SKSpriteNode(texture: texture, color: .white, size: texture.size())
        super.init()
    }
  
  // 5
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
