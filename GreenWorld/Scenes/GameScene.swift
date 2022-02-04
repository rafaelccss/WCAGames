import SpriteKit
import GameplayKit

class GameScene: SKScene {

    // MARK: - Entities

    private var player: SKShapeNode?
    let ground = Ground(size: CGSize(width: 500, height: 10))
    let platarform = Plataform()
    
    
    override func didMove(to view: SKView) {
        //Nodes
        self.setupNodesPosition()
    }

    // MARK: - Adding Nodes to Scene

    func setupNodesPosition() {
        guard let groundComponent = ground.component(ofType: GroundComponent.self)?.groundNode,
              let plataformComponet = platarform.component(ofType: PlataformComponent.self)?.plataformNode else { return }
        groundComponent.position = CGPoint(x: scene!.frame.minX + groundComponent.size.width/2, y: 50)
        plataformComponet.position = positionBasedOnLastElement(lastNode: groundComponent,
                                                                presentNode: plataformComponet,
                                                                dx: 0,
                                                                dy: 80)
        self.addChild(groundComponent)
        self.addChild(plataformComponet)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            print(touch.location(in: self.view))
        }
    }

    func positionBasedOnLastElement(lastNode: SKSpriteNode,
                                    presentNode: SKSpriteNode,
                                    dx: CGFloat, dy: CGFloat) -> CGPoint {
        let xPositionPlataform = lastNode.position.x + (lastNode.size.width + presentNode.size.width) * 0.5 + dx
        let yPositionPlataform = lastNode.position.y + dy

        return CGPoint(x: xPositionPlataform, y: yPositionPlataform)
    }
}
