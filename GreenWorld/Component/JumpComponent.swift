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

	func jump(completion: @escaping () -> Void = { }) {
        print("jump")
		let sequence = SKAction.sequence([
			SKAction.move(by: CGVector(dx: 150, dy: impulse), duration: 0.75),
			SKAction.move(by: CGVector(dx: 150, dy: -impulse), duration: 0.75)
		])
		sequence.duration = 1.5
		sequence.timingMode = .easeIn
		
		animatedSpriteComponent?.spriteNode.run(sequence, completion: completion)
	}
}

