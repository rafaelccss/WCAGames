import Foundation
import SpriteKit
import GameplayKit

class EntityManager {
  // 1
  var entities = Set<GKEntity>()
  let scene: SKScene
    var player = Player()
    var shots = Set<GKEntity>()

  // 2
  init(scene: SKScene) {
    self.scene = scene
  }

  // 3
  func add(_ entity: GKEntity) {
    entities.insert(entity)

    if let spriteNode = entity.component(ofType: AnimatedSpriteComponent.self)?.spriteNode {
      scene.addChild(spriteNode)
    }
  }
  // 4
  func remove(_ entity: GKEntity) {
    if let spriteNode = entity.component(ofType: AnimatedSpriteComponent.self)?.spriteNode {
      spriteNode.removeFromParent()
    }

    entities.remove(entity)
  }
    func getPlayer()->Player{
        return self.player
    }
    func addShot(_ entity:GKEntity){
        shots.insert(entity)

        if let spriteNode = entity.component(ofType: AnimatedSpriteComponent.self)?.spriteNode {
          scene.addChild(spriteNode)
        }
    }
    
    func removeShot(_ entity:GKEntity){
        if let spriteNode = entity.component(ofType: AnimatedSpriteComponent.self)?.spriteNode {
          spriteNode.removeFromParent()
        }
        shots.remove(entity)
    }
    
    func playerAttack(){
        guard let playerNode = player.component(ofType: AnimatedSpriteComponent.self)?.spriteNode else {return}
        let direction:MoveDirection = playerNode.xScale == 1 ? .right : .left
        let shot = ShotEntity(entityManager: self, power: .None, direction: direction)
        self.addShot(shot)
    }
    
    func updateShot(_ deltaTime:TimeInterval){
        for shot in shots{
            if let moveComponent = shot.component(ofType: WalkComponent.self){
                moveComponent.update(deltaTime: deltaTime)
            }
        }
    }
}
