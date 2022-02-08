//
//  GWStateMachine.swift
//  GreenWorld
//
//  Created by Luís Filipe Nascimento on 08/02/22.
//

import UIKit
import GameplayKit

class GWStateMachine: GKStateMachine {
    var previousState: GKState?
    
    func enterTo(_ stateClass: AnyClass) {
        self.previousState = self.currentState
        super.enter(stateClass)
    }
}
