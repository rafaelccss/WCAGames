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
    case None = "Arrow"
    case Tupã = "Thunder"
    case Polo = "Polo"
    case Sumá = "Sumá"
    case Guaraci = "Fire"
    case Mboi = "Mboi"
}

enum EnemyType {
    case Madeireiro
    case Boss
    case Garimpeiro
}
