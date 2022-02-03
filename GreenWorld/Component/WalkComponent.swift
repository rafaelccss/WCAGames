import GameplayKit

class WalkComponent: GKComponent {
    
    var direction: WalkDirection = .none
    var velocity: CGFloat
    
    var spriteNode: SKSpriteNode? {
        self.entity?.component(ofType: AnimatedSpriteComponent.self)?.spriteNode
    }
    
    init(velocity: CGFloat = 10) {
        self.velocity = velocity
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func walk(_ direction: WalkDirection) {
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
            spriteNode?.position.x -= velocity
            
        case .right:
            spriteNode?.xScale = 1
            spriteNode?.position.x += velocity
            
        default:
            break
        }
    }
}
