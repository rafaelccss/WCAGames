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
                AttackState(self),
                JumpState(self),
                LeftWalkState(self),
                RightWalkState(self)
            ])
        )
        
        self.addComponent(WalkComponent())
        self.addComponent(JumpComponent(impulse: 600))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Player:ContactNotifiable{
    func contactDidBegin(with entity: GKEntity, _ manager: EntityManager) {
        if entity is ShotEntity{
            guard let shotComponent = entity.component(ofType: ShotComponent.self) else {return}
            self.life -= shotComponent.damage
            self.life = self.life < 0 ? 0 : self.life
        }
    }
}
