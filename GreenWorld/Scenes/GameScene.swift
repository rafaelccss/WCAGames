import SpriteKit
import GameplayKit

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    private var player: SKShapeNode?
    var entityManager: EntityManager!
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
    }
}
