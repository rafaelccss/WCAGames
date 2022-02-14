import UIKit
import GameplayKit

class JumpState: GKState {
    
    var entity: GKEntity
    var dx: CGFloat {
        0
    }
    
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
        
        animatedSpriteComponent?.setAnimation(imageName: "Jump_", rangeOfAnimation: 0...9)
        jumpComponent?.jump(dx: dx)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
    }
    
}
