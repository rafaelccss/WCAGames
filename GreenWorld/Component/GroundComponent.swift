import Foundation
import GameplayKit

class GroundComponent: GKComponent {
    var groundNode: SKSpriteNode
    /*
     Enmum do tipo tamanho para definir o tamanho das plataformas que Niara irá pular.
     */

    override init() {
        self.groundNode = SKSpriteNode(color: SKColor.red,
                                       size: CGSize(width: UIScreen.main.bounds.width, height: 200))
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
