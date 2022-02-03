import UIKit
import SpriteKit
import GameplayKit

class AnimatedSpriteComponent: GKComponent {
    var spriteNode: SKSpriteNode!
    
    var animationAtlas: SKTextureAtlas?
    var animationTextures: [SKTexture] {
        animationAtlas?.textureNames.compactMap({ texture in
            animationAtlas?.textureNamed(texture)
        }) ?? []
    }
    
    init(atlasName: String) {
        super.init()
        
        self.animationAtlas = SKTextureAtlas(named: atlasName)
        self.spriteNode = SKSpriteNode(imageNamed: animationAtlas!.textureNames.first!)
        self.spriteNode.texture = animationTextures.first!
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAnimation(atlasName: String) {
        spriteNode.removeAllActions()
        
        self.animationAtlas = SKTextureAtlas(named: atlasName)
        self.spriteNode.texture = animationTextures.first!
        
        spriteNode.run(
            SKAction.repeatForever(
                SKAction.animate(
                    with: animationTextures,
                    timePerFrame: 0.1,
                    resize: false,
                    restore: true
                )
            )
        )
    }
}
