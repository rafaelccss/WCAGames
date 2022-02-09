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
        
		//animatedSpriteComponent?.setAnimation(atlasName: Textures.shot.rawValue, rangeOfAnimation: <#ClosedRange<Int>#>)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
    }
}
