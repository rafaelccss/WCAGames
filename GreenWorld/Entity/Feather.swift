import UIKit
import GameplayKit

protocol CollecteddFeatherDelegate {
    func collected(_ feather: Feather)
}

class Feather: GKEntity {
    
    var delegate: CollecteddFeatherDelegate?
    
    override init() {
        super.init()
        
        let featherNode = SKSpriteNode(imageNamed: "Feather_\(Int.random(in: 0...3))")
        featherNode.size = CGSize(width: 32, height: 32)
        addPhysics(featherNode)
        
        self.addComponent(AnimatedSpriteComponent(spriteNode: featherNode))
        let rotation = RotationYComponent()
        self.addComponent(rotation)
        rotation.rotateForever()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addPhysics(_ node: SKSpriteNode) {
        node.physicsBody = SKPhysicsBody(texture: node.texture!, size: node.size)
        node.physicsBody?.categoryBitMask = CollisionType.feather.rawValue
        node.physicsBody?.contactTestBitMask = CollisionType.player.rawValue
       // node.physicsBody?.collisionBitMask = CollisionType.player.rawValue
        node.physicsBody?.isDynamic = false
    }
}

extension Feather: ContactNotifiable {
    func contactDidBegin(with entity: GKEntity, _ manager: EntityManager) {
        if entity is Player {
            delegate?.collected(self)
            self.component(ofType: AnimatedSpriteComponent.self)!.spriteNode.removeFromParent()
        }
    }
}
