import UIKit
import SpriteKit
import GameplayKit

class AnimatedSpriteComponent: GKComponent {

    var spriteNode: SKSpriteNode!

    init(imageName: String) {
        super.init()
        let texture = SKTexture(imageNamed: imageName)
        self.spriteNode = SKSpriteNode(texture: texture, size: CGSize(width: 50, height: 90))
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
    
	func setAnimation(imageName: String, rangeOfAnimation: ClosedRange<Int>) {
		
		let animation: SKAction = .repeatForever(.animate(with:
														Array(withFormat: imageName, range: rangeOfAnimation),
                                                          timePerFrame: 0.1))
		self.spriteNode.run(animation)
    }
	
	func haltActions() {
		spriteNode?.removeAllActions()
	}
	
}
public extension Array where Element == SKTexture {

	init (withFormat format: String, range: ClosedRange<Int>) {

		self = range.map({ (index) in
			let imageNamed = format + "\(index)"
			return SKTexture(imageNamed: imageNamed)
		})
	}
}
