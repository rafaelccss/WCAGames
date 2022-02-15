import Foundation
import GameplayKit

class PlataformComponent: GKComponent {

    // MARK: - Properties

    var plataformNode: SKSpriteNode!

    // MARK: - Init

    init(imageName: String) {
        super.init()
        let texture = SKTexture(imageNamed: imageName)
        self.plataformNode = SKSpriteNode(texture: texture, size: CGSize(width: 200, height: 48))

    }

    override func didAddToEntity() {
        self.plataformNode.entity = self.entity
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
