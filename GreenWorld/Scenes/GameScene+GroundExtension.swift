import SpriteKit
import GameplayKit

extension GameScene {
    func setupCoinPosition() {
        let firstGround = entityManager.getGround(position: 0)
        let inicialGroundNode = firstGround.component(ofType: GroundComponent.self)?.groundNode
        let coin = Coin()
        coin.component(ofType: AnimatedSpriteComponent.self)?.spriteNode.position = positionBasedOnLastElement(lastNode: inicialGroundNode!,
                                                                                                               presentNode: coin.component(ofType: AnimatedSpriteComponent.self)!.spriteNode,
                                                                                                               dx: -400,
                                                                                                               dy: 30)
        addChild(coin.component(ofType: AnimatedSpriteComponent.self)!.spriteNode)
        coin.delegate = self
        coins.append(coin)
        
    }
}
