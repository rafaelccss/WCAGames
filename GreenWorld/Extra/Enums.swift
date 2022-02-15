import Foundation

enum CollisionType: UInt32 {

    case player = 1
    case enemy = 2
    case playerWeapon = 4
    case enemyWeapon = 8
    case ground = 16
    case feather = 32
    case invisibleGround = 64
}

enum Powers: String {
    case None = "Nonde"
    case Tupã = "Tupã"
    case Polo = "Polo"
    case Sumá = "Sumá"
    case Guaraci = "Guaraci"
    case Mboi = "Mboi"
}

enum EnemyType{
    case Madeireiro
    case Boss
    case Garimpeiro
}
