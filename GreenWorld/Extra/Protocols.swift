//
//  Protocols.swift
//  GreenWorld
//
//  Created by Nathan Batista de Oliveira on 04/02/22.
//

import Foundation
import GameplayKit

protocol ContactNotifiable{
    func contactDidBegin(with entity: GKEntity,_ manager:EntityManager)
}
