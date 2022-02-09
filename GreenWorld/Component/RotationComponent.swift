import Foundation
import SpriteKit
import GameplayKit


class RotationComponent: GKComponent {
	
	var spriteNode: SKSpriteNode? {
		self.entity?.component(ofType: AnimatedSpriteComponent.self)?.spriteNode
	}
	
	func rotate(_ angle: CGFloat = .pi*2, duration: TimeInterval) {
		
		spriteNode?.run(SKAction.repeatForever(SKAction.rotate(byAngle: angle, duration: duration)))

	}
	
}
