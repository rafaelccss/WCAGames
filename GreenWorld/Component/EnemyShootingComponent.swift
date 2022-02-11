import Foundation
import GameplayKit
import SpriteKit

class EnemyShotComponent : GKComponent{
    var damage = 0
    var entityManager:EntityManager!
    
    init(enemy enemyEntity:Enemy, manager entityManager:EntityManager){
        self.damage = 25
        self.entityManager = entityManager
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
