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
}
