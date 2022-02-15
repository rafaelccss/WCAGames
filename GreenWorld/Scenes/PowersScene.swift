//
//  PowersScene.swift
//  GreenWorld
//
//  Created by Luís Filipe Nascimento on 14/02/22.
//

import UIKit
import SpriteKit
import GameplayKit

class PowersScene: SKScene {
    
    let powers: [Powers]!
    var powersNode = [PowerNode]()
    var powerSelected: Powers!
    let confirmLabel = SKLabelNode(text: "Confirm")
    var handle: HandleWithScenes?
    
    init(size: CGSize, powers: [Powers]) {
        self.powers = powers
        super.init(size: size)
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .black
        if self.children.count == 0 {
            generatePowerNodes(powers)
        }
    }
    
    func generatePowerNodes(_ with: [Powers]) {
        let width = self.size.width / CGFloat(powers.count) * 0.45
        let spacing = self.size.width * 0.03
        let leftOffset: CGFloat = (self.size.width - width * CGFloat(powers.count) - spacing * CGFloat(powers.count - 1)) / 2
        for i in 0 ..< powers.count {
            let xSpacingOffset: CGFloat = leftOffset + spacing * CGFloat(i)
            let xWidthOffset: CGFloat = width * CGFloat(i)
            let node = PowerNode(size: CGSize(width: width, height: width * 1.5),
                                 cornerRadius: 8,
                                 power: powers[i])
            node.position = CGPoint(x: xSpacingOffset + xWidthOffset,
                                    y: self.frame.midY - width * 0.35)
            powersNode.append(node)
            node.alpha = 0
        }
        
        confirmLabel.position = CGPoint(x: self.frame.midX, y: self.frame.minY + confirmLabel.frame.height / 2 + self.size.height * 0.1)
        addChild(confirmLabel)
        showNodes()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        
        if confirmLabel.contains(location) {
            if powerSelected != nil {
                handle?.didSelectPower(powerSelected)
            }
        } else {
            var nodeSelected: PowerNode?
            
            for node in powersNode {
                if node.contains(location) {
                    nodeSelected = node
                    node.isSelected = true
                    powerSelected = node.power
                    break
                }
            }
            
            if let nodeSel = nodeSelected {
                for node in powersNode.filter({ $0 !=  nodeSel}) {
                    node.isSelected = false
                }
            }
        }
    }
    
    func showNodes() {
        let buttonFadeInTime = 0.25
        
        for node in powersNode {
            addChild(node)
            node.run(.fadeIn(withDuration: buttonFadeInTime))
        }
    }
}
