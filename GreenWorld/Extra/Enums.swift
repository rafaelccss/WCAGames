import Foundation

enum CollisionType: UInt32 {

    case player = 1
    case enemy = 2
    case playerWeapon = 4
    case enemyWeapon = 8
    case ground = 16
}

enum Powers {

    case None
    case Tupã
    case Polo
    case Sumá
    case Guaraci
    case Mboi
}
