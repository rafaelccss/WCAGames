import SpriteKit
import GameplayKit

class Player: GKEntity {
    
    var life: Int = 100

    override init() {
        super.init()
        
        self.addComponent(AnimatedSpriteComponent(atlasName: ""))
        
        self.addComponent(
            PlayerControlComponent(states: [
                IdleState(self),
            ])
        )
        
        self.addComponent(WalkComponent())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
