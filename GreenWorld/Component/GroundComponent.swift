import Foundation
import UIKit
import SpriteKit
import GameplayKit

class GroundComponent: GKComponent {

    // MARK: - Properties

    var groundNode: SKSpriteNode!

    // MARK: - Init

    init(size: CGSize) {
        super.init()
        let texture = SKTexture(imageNamed: "Ground")
        self.groundNode = SKSpriteNode(texture: texture, size: size)
    }
    
    override func didAddToEntity() {
        self.groundNode.entity = self.entity
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
