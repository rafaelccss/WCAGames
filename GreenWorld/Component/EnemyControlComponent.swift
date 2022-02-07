import GameplayKit

class EnemyControlComponent: GKComponent {

    var stateMachine: GKStateMachine
    
    init(states: [GKState]) {
        self.stateMachine = GKStateMachine(states: states)
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handle(direction: MoveDirection) {
        switch direction {
        case .left:
            moveLeft()
        case .right:
            moveRight()
        default: break
        }
    }
    
    func halt() {
        stateMachine.enter(IdleState.self)
    }
    
    func moveLeft() {
        stateMachine.enter(LeftWalkState.self)
    }
    
    func moveRight() {
        stateMachine.enter(RightWalkState.self)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        self.entity?.component(ofType: WalkComponent.self)?.update(deltaTime: seconds)
    }
}
