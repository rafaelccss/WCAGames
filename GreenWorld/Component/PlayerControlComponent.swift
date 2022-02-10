import GameplayKit

class PlayerControlComponent: GKComponent {
    
    var stateMachine: GWStateMachine
    
    init(states: [GKState]) {
        self.stateMachine = GWStateMachine(states: states)
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
        
        stateMachine.enterTo(IdleState.self)
    }
    
    func jump() {
        guard stateMachine.currentState?.classForCoder != JumpState.self else { return }
        guard stateMachine.currentState?.classForCoder != RightJumpState.self else { return }
        guard stateMachine.currentState?.classForCoder != LeftJumpState.self else { return }
//        guard stateMachine.previousState?.classForCoder != JumpState.self else { return }
//        guard stateMachine.previousState?.classForCoder != RightJumpState.self else { return }
//        guard stateMachine.previousState?.classForCoder != LeftJumpState.self else { return }
        if let state = stateMachine.previousState?.classForCoder {
            if state === RightWalkState.self {
                stateMachine.enterTo(RightJumpState.self)
            } else if state === LeftWalkState.self {
                stateMachine.enterTo(LeftJumpState.self)
            } else if state === IdleState.self{
                stateMachine.enterTo(JumpState.self)
            }
        } else {
            stateMachine.enterTo(JumpState.self)
        }
    }
    
    func moveLeft() {
        stateMachine.enterTo(LeftWalkState.self)
    }
    
    func moveRight() {
        stateMachine.enterTo(RightWalkState.self)
    }
    
    func attack() {
        guard stateMachine.currentState?.classForCoder != JumpState.self else { return }
        guard stateMachine.currentState?.classForCoder != RightJumpState.self else { return }
        guard stateMachine.currentState?.classForCoder != LeftJumpState.self else { return }
        
        stateMachine.enterTo(AttackState.self)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        self.entity?.component(ofType: WalkComponent.self)?.update(deltaTime: seconds)
    }
}
