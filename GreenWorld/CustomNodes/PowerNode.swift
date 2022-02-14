//
//  PowerNode.swift
//  GreenWorld
//
//  Created by Luís Filipe Nascimento on 14/02/22.
//

import UIKit
import SpriteKit

class PowerNode: SKShapeNode {
    init(origin: CGPoint, size: CGSize, cornerRadius: CGFloat) {
        super.init()
        let myPath:CGPath = UIBezierPath(roundedRect: CGRect(origin: origin, size: size),
                                         cornerRadius: cornerRadius).cgPath
        self.path = myPath
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
