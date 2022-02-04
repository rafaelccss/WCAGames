import SpriteKit
import GameplayKit

class GameScene: SKScene {

    // MARK: - Entities

    let player = Player()
    let ground = Ground(size: CGSize(width: 500, height: 10))
    let platarform = Plataform()

    private var previousUpdateTime: TimeInterval = TimeInterval()
    var playerControlComponent: PlayerControlComponent? {
        player.component(ofType: PlayerControlComponent.self)
    }

    // MARK: - Gestures
    // lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(attack))
    lazy var panGesture = UIPanGestureRecognizer(target: self, action: #selector(walk))

    @objc
    func walk(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            playerControlComponent?.handle(direction: sender.direction)

        case .ended:
            playerControlComponent?.halt()

        default:
            break
        }
    }

    override func update(_ currentTime: TimeInterval) {

        let timeSincePreviousUpdate = currentTime - previousUpdateTime
        playerControlComponent?.update(deltaTime: timeSincePreviousUpdate)
        previousUpdateTime = currentTime
    }

    override func didMove(to view: SKView) {
        // MARK: - Nodes
        self.setupNodesPosition()
        view.addGestureRecognizer(panGesture)
    }

    // MARK: - Adding Nodes to Scene

    func setupNodesPosition() {
        guard let groundComponent = ground.component(ofType: GroundComponent.self)?.groundNode,
              let plataformComponent = platarform.component(ofType: PlataformComponent.self)?.plataformNode,
              let playerNode = player.component(ofType: AnimatedSpriteComponent.self)?.spriteNode else { return }
        groundComponent.position = CGPoint(x: scene!.frame.minX + groundComponent.size.width/2, y: 50)
        plataformComponent.position = positionBasedOnLastElement(lastNode: groundComponent,
                                                                presentNode: plataformComponent,
                                                                dx: 0,
                                                                dy: 80)
        playerNode.position = positionBasedOnLastElement(lastNode: groundComponent,
                                                         presentNode: playerNode,
                                                         dx: -200,
                                                         dy: 45 + groundComponent.size.height/2)
        self.addChild(groundComponent)
        self.addChild(plataformComponent)
        self.addChild(playerNode)
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
