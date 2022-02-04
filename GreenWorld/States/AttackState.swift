//
//  AttackState.swift
//  GreenWorld
//
//  Created by Luís Filipe Nascimento on 04/02/22.
//

import UIKit
import GameplayKit

class AttackState: GKState {
    var entity: GKEntity
    
    var animatedSpriteComponent: AnimatedSpriteComponent? {
        self.entity.component(ofType: AnimatedSpriteComponent.self)
    }
    
    init(_ entity: GKEntity) {
        self.entity = entity
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        animatedSpriteComponent?.setAnimation(atlasName: Textures.shot.rawValue)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
    }
}
