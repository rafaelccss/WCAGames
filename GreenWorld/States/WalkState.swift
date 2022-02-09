import UIKit
import GameplayKit

class WalkState: GKState {
    var entity: GKEntity
    
    var direction: MoveDirection {
        .none
    }
    
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
        
		animatedSpriteComponent?.setAnimation(atlasName: "Run_", rangeOfAnimation: 0...9)
        walkComponent?.walk(direction)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
    }
}

class LeftWalkState: WalkState {
    override var direction: MoveDirection {
        .left
    }
}

class RightWalkState: WalkState {
    override var direction: MoveDirection {
        .right
    }
}
