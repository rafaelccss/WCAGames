import Foundation
import GameplayKit

class PlataformComponent: GKComponent {

    // MARK: - Properties

    var plataformNode: SKSpriteNode

    // MARK: - Init

    override init() {
        self.plataformNode = SKSpriteNode(color: SKColor.brown,
                                       size: CGSize(width: 200, height: 10))
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
