import UIKit
import SpriteKit

class PowerNode: SKShapeNode {
    
    let imageNode: SKSpriteNode!
    let nameNode: SKLabelNode!
    let power: Powers!
    var isSelected = false {
        willSet {
            if newValue {
                strokeColor = .green
                nameNode.fontColor = .green
            } else {
                strokeColor = .gray
                nameNode.fontColor = .white
            }
        }
    }
    
    init(size: CGSize, cornerRadius: CGFloat, power: Powers) {
        imageNode = SKSpriteNode(imageNamed: power.rawValue)
        nameNode = SKLabelNode(text: power.rawValue)
        self.power = power
        super.init()
        let myPath:CGPath = UIBezierPath(roundedRect: CGRect(origin: .zero, size: size),
                                         cornerRadius: cornerRadius).cgPath
        self.path = myPath
        configureChildrenNodes()
        fillColor = .black
        strokeColor = .gray
    }
    
    func configureChildrenNodes() {
        let width = self.frame.width
        
        self.imageNode.size = CGSize(width: width + 2, height: self.frame.height * 0.7)
        self.imageNode.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - imageNode.size.height / 2 + 1)
        self.imageNode.scene?.scaleMode = .aspectFill
        
        self.nameNode.position = CGPoint(x: self.frame.midX, y: self.frame.minY + self.frame.height * 0.1)
        self.nameNode.fontColor = .white
        
        addChild(self.imageNode)
        addChild(self.nameNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
