//
//  IdleState.swift
//  GreenWorld
//
//  Created by Luís Filipe Nascimento on 03/02/22.
//

import UIKit
import GameplayKit

class IdleState: GKState {
    var entity: GKEntity
    
    var animatedSpriteComponent: AnimatedSpriteComponent? {
        self.entity.component(ofType: AnimatedSpriteComponent.self)
    }
    
    var walkComponent: WalkComponent? {
        self.entity.component(ofType: WalkComponent.self)
    }
    
    init(_ entity: GKEntity) {
        self.entity = entity
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        
    }
}
