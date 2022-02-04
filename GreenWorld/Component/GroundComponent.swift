import Foundation
import GameplayKit

class GroundComponent: GKComponent {

    // MARK: - Properties

    var groundNode: SKSpriteNode

    // MARK: - Init

    init(size: CGSize) {
        self.groundNode = SKSpriteNode(color: SKColor.brown,
                                       size: size)
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
