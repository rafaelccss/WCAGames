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
        case .none:
            <#code#>
        case .left:
            <#code#>
        case .right:
            <#code#>
        case .jump:
            <#code#>
        }
    }
}
