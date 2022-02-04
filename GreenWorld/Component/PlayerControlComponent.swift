//
//  PlayerControlComponent.swift
//  GreenWorld
//
//  Created by Luís Filipe Nascimento on 03/02/22.
//

import UIKit
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
        case .jump:
            jump()
        default: break
        }
    }
    
    func halt() {
        guard stateMachine.currentState!.classForCoder != JumpState.self else { return }
        
        stateMachine.enter(IdleState.self)
    }
    
    func jump() {
        stateMachine.enter(JumpState.self)
    }
    
    func moveLeft() {
        stateMachine.enter(LeftWalkState.self)
    }
    
    func moveRight() {
        stateMachine.enter(RightWalkState.self)
    }
    
    func attack() {
        guard stateMachine.currentState!.classForCoder != JumpState.self else { return }
        
        stateMachine.enter(AttackState.self)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        self.entity?.component(ofType: WalkComponent.self)?.update(deltaTime: seconds)
    }
}
