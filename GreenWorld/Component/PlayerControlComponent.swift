import GameplayKit

class PlayerControlComponent: GKComponent {
    
    var stateMachine: GKStateMachine
    
    init(states: [GKState]) {
        self.stateMachine = GKStateMachine(states: states)
        //self.stateMachine.enter()
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
        case .up:
            jump()
        default: break
        }
    }
    
    func halt() {
        guard stateMachine.currentState?.classForCoder != JumpState.self else { return }
        
        stateMachine.enter(IdleState.self)
    }
    
    func jump() {
        if let state = stateMachine.currentState?.classForCoder {
            if state == RightWalkState.self {
                stateMachine.enter(RightJumpState.self)
            } else if state == LeftJumpState.self {
                stateMachine.enter(LeftJumpState.self)
            } else {
                stateMachine.enter(JumpState.self)
            }
        } else {
            stateMachine.enter(JumpState.self)
        }
    }
    
    func moveLeft() {
        stateMachine.enter(LeftWalkState.self)
    }
    
    func moveRight() {
        stateMachine.enter(RightWalkState.self)
    }
    
    func attack() {
        guard stateMachine.currentState?.classForCoder != JumpState.self else { return }
        
        stateMachine.enter(AttackState.self)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        self.entity?.component(ofType: WalkComponent.self)?.update(deltaTime: seconds)
    }
}
