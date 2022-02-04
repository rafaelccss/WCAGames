//
//  Enums.swift
//  GreenWorld
//
//  Created by Nathan Batista de Oliveira on 04/02/22.
//

import Foundation

enum CollisionType:UInt32{
    case player = 1
    case Enemy = 2
    case playerWeapon = 4
    case enemyWeapon = 8
}

enum Powers{
    case None
    case Tupã
    case Polo
    case Sumá
    case Guaraci
    case Mboi
}
