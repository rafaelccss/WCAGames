import GameplayKit

class WalkComponent: GKComponent {
    
    var direction: MoveDirection = .none
    var velocity: CGFloat
    
    var spriteNode: SKSpriteNode? {
        self.entity?.component(ofType: AnimatedSpriteComponent.self)?.spriteNode
    }
    
    init(velocity: CGFloat = 1) {
        self.velocity = velocity
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func walk(_ direction: MoveDirection) {
        self.direction = direction
    }
    
    func halt() {
        self.direction = .none
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        switch direction {
        case .left:
            spriteNode?.xScale = -1
            spriteNode?.physicsBody?.applyImpulse(CGVector(dx: -velocity, dy: 0))
        case .right:
            spriteNode?.xScale = 1
            spriteNode?.physicsBody?.applyImpulse(CGVector(dx: velocity, dy: 0))
            
        default:
            break
        }
    }
}
