import Foundation
import SpriteKit
import GameplayKit


class JumpComponent: GKComponent {

	let impulse: CGFloat
	//variável do tipo computada
	var dx: CGFloat? {
		self.entity?.component(ofType: WalkComponent.self)?.velocity
	}

	var animatedSpriteComponent: AnimatedSpriteComponent? {
		self.entity?.component(ofType: AnimatedSpriteComponent.self)
	}

	init(impulse: CGFloat) {
		self.impulse = impulse
		super.init()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func jump(dx: CGFloat, completion: @escaping () -> Void = { }) {
        animatedSpriteComponent?.spriteNode.physicsBody?.applyImpulse(CGVector(dx: dx, dy: 25))
        
        completion()
	}
}

