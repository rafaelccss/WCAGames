import Foundation
import SpriteKit
import GameplayKit

class EntityManager {

    var entities = Set<GKEntity>()
    var grounds = [GKEntity]()
    let scene: SKScene
    var player = Player()
    var shots = Set<GKEntity>()
    var coins = [Coin]()

    init(scene: SKScene) {
        self.scene = scene
    }

    func add(_ entity: GKEntity) {
        entities.insert(entity)

        if let spriteNode = entity.component(ofType: AnimatedSpriteComponent.self)?.spriteNode {
            scene.addChild(spriteNode)
        }
    }

    func addGroundAndPlataform(_ entity: GKEntity) {
        grounds.append(entity)

        if let spriteNode = entity.component(ofType: GroundComponent.self)?.groundNode {
            scene.addChild(spriteNode)
        }

        if let spriteNode = entity.component(ofType: PlataformComponent.self)?.plataformNode {
            scene.addChild(spriteNode)
        }
    }

    func addShot(_ entity:GKEntity){
        shots.insert(entity)

        if let spriteNode = entity.component(ofType: AnimatedSpriteComponent.self)?.spriteNode {
            scene.addChild(spriteNode)
        }
    }

    func getPlayer() -> Player {
        return self.player
    }

    func playerAttack(){
        guard let playerNode = player.component(ofType: AnimatedSpriteComponent.self)?.spriteNode else { return }
        if let scene = playerNode.scene{
            let direction:MoveDirection = playerNode.xScale == 1 ? .right : .left
            let shot = ShotEntity(entityManager: self, power: .None, direction: direction)
            self.addShot(shot)
        }
    }

    func remove(_ entity: GKEntity) {
        if let spriteNode = entity.component(ofType: AnimatedSpriteComponent.self)?.spriteNode {
            spriteNode.removeFromParent()
        }

        entities.remove(entity)
    }

    func removeShot(_ entity:GKEntity){
        if let spriteNode = entity.component(ofType: AnimatedSpriteComponent.self)?.spriteNode {
            spriteNode.removeFromParent()
        }
        shots.remove(entity)
    }
    
    func updateShot(_ deltaTime:TimeInterval) {
        for shot in shots{
            if let moveComponent = shot.component(ofType: WalkComponent.self){
                moveComponent.update(deltaTime: deltaTime)
            }
        }
    }
    func addGround(_ entity:GKEntity){
        grounds.append(entity)

        if let spriteNode = entity.component(ofType: GroundComponent.self)?.groundNode{
          scene.addChild(spriteNode)
        }
        if let spriteNode = entity.component(ofType: PlataformComponent.self)?.plataformNode{
          scene.addChild(spriteNode)
        }
    }
    
    func addGrounds(){
        
        let inicialGround = Ground(size: CGSize(width: 500, height: 10))
        
        let enemy = Enemy(manager: self)

        guard let playerNode = player.component(ofType: AnimatedSpriteComponent.self)?.spriteNode,
              let inicialGroundNode = inicialGround.component(ofType: GroundComponent.self)?.groundNode,
              let enemyNode = enemy.component(ofType: AnimatedSpriteComponent.self)?.spriteNode else { return }

        inicialGroundNode.position = CGPoint(x: scene.frame.minX + inicialGroundNode.size.width/2, y: 50)
        playerNode.position = positionBasedOnLastElement(lastNode: inicialGroundNode,
                                                         presentNode: playerNode,
                                                         dx: -200,
                                                         dy: 45 + inicialGroundNode.size.height/2)
        enemyNode.position = positionBasedOnLastElement(lastNode: inicialGroundNode,
                                                        presentNode: enemyNode,
                                                        dx: -100,
                                                        dy: enemyNode.size.height + inicialGroundNode.size.height / 2 + 10)

        self.addGroundAndPlataform(inicialGround)
        self.add(player)
        self.add(enemy)
    
        var lastNode = inicialGroundNode


        for _  in 1 ... 4 {
            let random = Int.random(in: 300 ... 600)
            let space = Int.random(in: 6 ... 13)
            let ground = Ground(size: CGSize(width: random, height: 10))
            let plaform = Plataform()

            guard let plaformNode = plaform.component(ofType: PlataformComponent.self)?.plataformNode else { return }
            plaformNode.position = positionBasedOnLastElement(lastNode: lastNode,
                                                              presentNode: plaformNode,
                                                              dx: CGFloat(space),
                                                              dy: 80)
            lastNode = plaformNode

            guard let groundNode = ground.component(ofType: GroundComponent.self)?.groundNode else { return }
            groundNode.position = positionBasedOnLastElement(lastNode: lastNode,
                                                             presentNode: groundNode,
                                                             dx: 0,
                                                             dy: -80)
            lastNode = groundNode


            self.addGroundAndPlataform(plaform)
            self.addGroundAndPlataform(ground)
        }
    }
    
    func getGround(position:Int) -> GKEntity{
        return grounds[position]
    }
    
    func positionBasedOnLastElement(lastNode: SKSpriteNode,
                                    presentNode: SKSpriteNode,
                                    dx: CGFloat, dy: CGFloat) -> CGPoint {
        let xPositionPlataform = lastNode.position.x + (lastNode.size.width + presentNode.size.width) * 0.5 + dx
        let yPositionPlataform = lastNode.position.y + dy
        
        return CGPoint(x: xPositionPlataform, y: yPositionPlataform)
    }
    func removePlayer(){
        guard let playerNode = player.component(ofType: AnimatedSpriteComponent.self)?.spriteNode else { return }
        playerNode.removeFromParent()
    }
}

