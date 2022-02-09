import SpriteKit
import GameplayKit

extension GameScene {
    func setupGroundPosition() {

        let inicialGround = Ground(size: CGSize(width: 500, height: 10))

        guard let playerNode = player.component(ofType: AnimatedSpriteComponent.self)?.spriteNode,
              let inicialGroundNode = inicialGround.component(ofType: GroundComponent.self)?.groundNode,
              let enemyNode = enemy.component(ofType: AnimatedSpriteComponent.self)?.spriteNode else { return }

        inicialGroundNode.position = CGPoint(x: scene!.frame.minX + inicialGroundNode.size.width/2, y: 50)
        playerNode.position = positionBasedOnLastElement(lastNode: inicialGroundNode,
                                                         presentNode: playerNode,
                                                         dx: -200,
                                                         dy: 45 + inicialGroundNode.size.height/2)
        enemyNode.position = positionBasedOnLastElement(lastNode: inicialGroundNode,
                                                        presentNode: enemyNode,
                                                        dx: -100,
                                                        dy: enemyNode.size.height + inicialGroundNode.size.height / 2 + 10)

        entityManager.addGroundAndPlataform(inicialGround)
        entityManager.add(player)
        entityManager.add(enemy)

        var lastNode = inicialGroundNode


        for _  in 1 ... 4 {
            let random = Int.random(in: 300 ... 600)
            let ground = Ground(size: CGSize(width: random, height: 10))
            let plaform = Plataform()

            // Espaço do ground para a plataforma ser aleatório
            guard let plaformNode = plaform.component(ofType: PlataformComponent.self)?.plataformNode else { return }
            plaformNode.position = positionBasedOnLastElement(lastNode: lastNode,
                                                              presentNode: plaformNode,
                                                              dx: 13,
                                                              dy: 80)
            lastNode = plaformNode

            guard let groundNode = ground.component(ofType: GroundComponent.self)?.groundNode else { return }
            groundNode.position = positionBasedOnLastElement(lastNode: lastNode,
                                                             presentNode: groundNode,
                                                             dx: 0,
                                                             dy: -80)
            lastNode = groundNode


            entityManager.addGroundAndPlataform(plaform)
            entityManager.addGroundAndPlataform(ground)
        }
    }
}
