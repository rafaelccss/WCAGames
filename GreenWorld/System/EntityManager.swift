import Foundation
import SpriteKit
import GameplayKit

class EntityManager {

    var entities = Set<GKEntity>()
    var grounds = Set<GKEntity>()
    let scene: SKScene
    var player = Player()
    var shots = Set<GKEntity>()

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
        grounds.insert(entity)

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
        let direction:MoveDirection = playerNode.xScale == 1 ? .right : .left
        let shot = ShotEntity(entityManager: self, power: .None, direction: direction)
        self.addShot(shot)
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
        grounds.insert(entity)

        if let spriteNode = entity.component(ofType: GroundComponent.self)?.groundNode{
          scene.addChild(spriteNode)
        }
        if let spriteNode = entity.component(ofType: PlataformComponent.self)?.plataformNode{
          scene.addChild(spriteNode)
        }
    }
    
    func addGrounds(){
        let groundOne = Ground(size: CGSize(width: 500, height: 10))
        let groundTwo = Ground(size: CGSize(width: 300, height: 10))
        let groundThree = Ground(size: CGSize(width: 600, height: 10))
        let groundFour = Ground(size: CGSize(width: 500, height: 10))

        let platarformOne = Plataform()
        let platarformTwo = Plataform()
        let platarformThree = Plataform()
        let platarformFour = Plataform()

        guard let groundComponentOne = groundOne.component(ofType: GroundComponent.self)?.groundNode,
              let groundComponentTwo = groundTwo.component(ofType: GroundComponent.self)?.groundNode,
              let groundComponentThree = groundThree.component(ofType: GroundComponent.self)?.groundNode,
              let groundComponentFour = groundFour.component(ofType: GroundComponent.self)?.groundNode,

              let plataformComponentOne = platarformOne.component(ofType: PlataformComponent.self)?.plataformNode,
              let plataformComponentTwo = platarformTwo.component(ofType: PlataformComponent.self)?.plataformNode,
              let plataformComponentThree = platarformThree.component(ofType: PlataformComponent.self)?.plataformNode,
              let plataformComponentFour = platarformFour.component(ofType: PlataformComponent.self)?.plataformNode else { return }
        

        groundComponentOne.position = CGPoint(x: scene.frame.minX + groundComponentOne.size.width/2, y: 50)
        plataformComponentOne.position = positionBasedOnLastElement(lastNode: groundComponentOne,
                                                                    presentNode: plataformComponentOne,
                                                                    dx: 0,
                                                                    dy: 80)
        groundComponentTwo.position = positionBasedOnLastElement(lastNode: plataformComponentOne,
                                                                 presentNode: groundComponentTwo,
                                                                 dx: 0,
                                                                 dy: -80)
        plataformComponentTwo.position = positionBasedOnLastElement(lastNode: groundComponentTwo,
                                                                    presentNode: plataformComponentTwo,
                                                                    dx: 0,
                                                                    dy: 80)
        groundComponentThree.position = positionBasedOnLastElement(lastNode: plataformComponentTwo,
                                                                    presentNode: groundComponentThree,
                                                                    dx: 0,
                                                                    dy: -80)
        plataformComponentThree.position = positionBasedOnLastElement(lastNode: groundComponentThree,
                                                                    presentNode: plataformComponentThree,
                                                                    dx: 0,
                                                                    dy: 80)
        groundComponentFour.position = positionBasedOnLastElement(lastNode: plataformComponentThree,
                                                                    presentNode: groundComponentFour,
                                                                    dx: 0,
                                                                    dy: -80)
        plataformComponentFour.position = positionBasedOnLastElement(lastNode: groundComponentFour,
                                                                      presentNode: plataformComponentFour,
                                                                      dx: 0,
                                                                      dy: 80)
        
        self.addGround(groundOne)
        self.addGround(groundTwo)
        self.addGround(groundThree)
        self.addGround(groundFour)
        self.addGround(platarformOne)
        self.addGround(platarformTwo)
        self.addGround(platarformThree)
        self.addGround(platarformFour)

    }
    
    func positionBasedOnLastElement(lastNode: SKSpriteNode,
                                    presentNode: SKSpriteNode,
                                    dx: CGFloat, dy: CGFloat) -> CGPoint {
        let xPositionPlataform = lastNode.position.x + (lastNode.size.width + presentNode.size.width) * 0.5 + dx
        let yPositionPlataform = lastNode.position.y + dy
        
        return CGPoint(x: xPositionPlataform, y: yPositionPlataform)
    }
}
