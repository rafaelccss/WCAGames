import UIKit
import GameplayKit

class JumpState: GKState {
    var entity: GKEntity
    
    init(_ entity: GKEntity) {
        self.entity = entity
        super.init()
    }
    
    var animatedSpriteComponent: AnimatedSpriteComponent? {
        self.entity.component(ofType: AnimatedSpriteComponent.self)
    }
    
    var jumpComponent: JumpComponent? {
        self.entity.component(ofType: JumpComponent.self)
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        animatedSpriteComponent?.setAnimation(atlasName: Textures.jump.rawValue)
        jumpComponent?.jump(completion: {
            self.stateMachine?.enter(IdleState.self)
        })
    }
    
}
