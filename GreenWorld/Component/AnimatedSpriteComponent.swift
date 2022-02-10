import UIKit
import SpriteKit
import GameplayKit

class AnimatedSpriteComponent: GKComponent {
    var spriteNode: SKSpriteNode!
    
//    var animationAtlas: SKTextureAtlas?
//    var animationTextures: [SKTexture] {
//        animationAtlas?.textureNames.compactMap({ texture in
//            animationAtlas?.textureNamed(texture)
//        }) ?? []
//    }
//
    init(atlasName: String) {
        super.init()
        
//        self.animationAtlas = SKTextureAtlas(named: atlasName)
        self.spriteNode = SKSpriteNode(color: .red, size: CGSize(width: 10, height: 90))
    
//        self.spriteNode = SKSpriteNode(imageNamed: animationAtlas!.textureNames.first!)
//        self.spriteNode.texture = animationTextures.first!
    }
    
    init(spriteNode: SKSpriteNode) {
        super.init()
        self.spriteNode = spriteNode
    }
    
    init(color: UIColor, size: CGSize) {
        super.init()
        self.spriteNode = SKSpriteNode(color: color, size: size)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        self.spriteNode.entity = self.entity
    }
    
    func setAnimation(atlasName: String) {
//        spriteNode.removeAllActions()
//        
//        self.animationAtlas = SKTextureAtlas(named: atlasName)
//        self.spriteNode.texture = animationTextures.first!
//        
//        spriteNode.run(
//            SKAction.repeatForever(
//                SKAction.animate(
//                    with: animationTextures,
//                    timePerFrame: 0.1,
//                    resize: false,
//                    restore: true
//                )
//            )
//        )
    }
}
