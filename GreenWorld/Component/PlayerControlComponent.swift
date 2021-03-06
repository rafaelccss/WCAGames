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
        //self.entity?.component(ofType: AnimatedSpriteComponent.self)?.spriteNode.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        stateMachine.enterTo(IdleState.self)
    }
    
    func jump() {
        guard stateMachine.currentState?.classForCoder != JumpState.self else { return }
        
        stateMachine.enter(JumpState.self)
    }
    
    func moveLeft() {
        stateMachine.enterTo(LeftWalkState.self)
    }
    
    func moveRight() {
        stateMachine.enterTo(RightWalkState.self)
    }
    
    func attack() {
        guard stateMachine.currentState?.classForCoder != JumpState.self else { return }
        
        stateMachine.enterTo(AttackState.self)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        self.entity?.component(ofType: WalkComponent.self)?.update(deltaTime: seconds)
    }
}
