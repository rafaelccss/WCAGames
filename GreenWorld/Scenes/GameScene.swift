import SpriteKit
import GameplayKit

class GameScene: SKScene {

    // MARK: - Entities

    private var player: SKShapeNode?
    let ground = Ground()
    
    override func didMove(to view: SKView) {
        //Nodes
        self.setupNodesPosition()
    }

    // MARK: - Adding Nodes to Scene

    func setupNodesPosition() {
        guard let groundComponent = ground.component(ofType: GroundComponent.self)?.groundNode else { return }

        groundComponent.zPosition = 2
        groundComponent.position = CGPoint(x: 0, y: 200)
        self.addChild(groundComponent)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            print(touch.location(in: self.view))
        }
    }
}
