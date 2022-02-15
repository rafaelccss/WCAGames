//
//  PowerNode.swift
//  GreenWorld
//
//  Created by Luís Filipe Nascimento on 14/02/22.
//

import UIKit
import SpriteKit

class PowerNode: SKShapeNode {
    
    let imageNode: SKSpriteNode!
    let nameNode: SKLabelNode!
    
    init(origin: CGPoint, size: CGSize, cornerRadius: CGFloat, power: Powers) {
        imageNode = SKSpriteNode(imageNamed: power.rawValue)
        nameNode = SKLabelNode(text: power.rawValue)
        super.init()
        let myPath:CGPath = UIBezierPath(roundedRect: CGRect(origin: origin, size: size),
                                         cornerRadius: cornerRadius).cgPath
        self.path = myPath
        configureChildrenNodes()
    }
    
    func configureChildrenNodes() {
        let width = self.frame.width
        self.imageNode.size = CGSize(width: width, height: self.frame.height * 0.7)
        self.imageNode.position = CGPoint(x: width / 2, y: 0)
        self.imageNode.scene?.scaleMode = .aspectFill
        addChild(self.imageNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
