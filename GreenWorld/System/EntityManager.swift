import Foundation
import SpriteKit
import GameplayKit

class EntityManager {

    var entities = Set<GKEntity>()
    var grounds = [GKEntity]()
    var platforms = Set<GKEntity>()
    let scene: GameScene
    var player = Player()
    var shots = Set<GKEntity>()
    var coins:[GKEntity] = []
    var enemies = Set<GKEntity>()
    let coinsCount = SKLabelNode(text: "000")
    let coinNode = SKSpriteNode(imageNamed: "Coin")
    let lifeLabel = SKLabelNode(text: "100")
    let heart = SKSpriteNode(imageNamed: "FullHeart")
    var lastXPlayerPosition:CGFloat = 0
    var currentPower: Powers = .None


    init(scene: GameScene) {
        self.scene = scene
    }

    func add(_ entity: GKEntity) {
        entities.insert(entity)

        if let spriteNode = entity.component(ofType: AnimatedSpriteComponent.self)?.spriteNode {
            scene.addChild(spriteNode)
        }
    }
    
    func addEnemy(_ entity: GKEntity) {
        enemies.insert(entity)

        if let spriteNode = entity.component(ofType: AnimatedSpriteComponent.self)?.spriteNode {
            scene.addChild(spriteNode)
        }
    }

    func addGroundAndPlataform(_ entity: GKEntity) {

        if let spriteNode = entity.component(ofType: GroundComponent.self)?.groundNode {
            grounds.append(entity)
            scene.addChild(spriteNode)
        }

        if let spriteNode = entity.component(ofType: PlataformComponent.self)?.plataformNode {
            platforms.insert(entity)
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
        if let _ = playerNode.scene {
            let direction:MoveDirection = playerNode.xScale == 1 ? .right : .left
            let shot = ShotEntity(entityManager: self, power: currentPower, direction: direction)
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
    
    func addGrounds(){
        
        let inicialGround = Ground(size: CGSize(width: 500, height: 10))
        
        guard let playerNode = player.component(ofType: AnimatedSpriteComponent.self)?.spriteNode,
              let inicialGroundNode = inicialGround.component(ofType: GroundComponent.self)?.groundNode else {return}
              

        inicialGroundNode.position = CGPoint(x: scene.frame.minX + inicialGroundNode.size.width/2, y: 50)
        playerNode.position = positionBasedOnLastElement(lastNode: inicialGroundNode,
                                                         presentNode: playerNode,
                                                         dx: -200,
                                                         dy: 45 + inicialGroundNode.size.height/2)
        

        self.addGroundAndPlataform(inicialGround)
        self.add(player)
    
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
    
    func configureScoreLabel() {
        let xPlayerPosition = player.component(ofType: AnimatedSpriteComponent.self)!.spriteNode.position.x
        heart.position = CGPoint(x: xPlayerPosition - scene.view!.frame.width / 2 + 52, y: scene.frame.maxY - 48)
        heart.size = CGSize(width: 48, height: 48)
        coinNode.position = CGPoint(x: heart.position.x + scene.view!.frame.width - 112, y: scene.frame.maxY - 48)
        coinNode.size = CGSize(width: 32, height: 32)
        lifeLabel.position = CGPoint(x: heart.position.x + heart.frame.width / 2 + 10 + lifeLabel.frame.width / 2, y: heart.position.y - lifeLabel.frame.height / 2)
        coinsCount.position = CGPoint(x: coinNode.position.x - coinNode.frame.width / 2 - 10 - coinsCount.frame.width / 2, y: coinNode.position.y - coinsCount.frame.height / 2)
        scene.addChild(coinNode)
        scene.addChild(coinsCount)
        scene.addChild(heart)
        scene.addChild(lifeLabel)
    }
    
    func updatePositionByPlayerPosition() {
        let playerX = player.component(ofType: AnimatedSpriteComponent.self)!.spriteNode.position.x
        let dx = playerX - lastXPlayerPosition
        lastXPlayerPosition = playerX
        heart.position.x += dx
        lifeLabel.position.x += dx
        coinsCount.position.x += dx
        coinNode.position.x += dx
    }
    
    func getGround(position:Int) -> GKEntity{
        return grounds[position]
    }
    
    func setupEnemy(){
        for index in 0..<grounds.count{
            let typeEnemy:EnemyType = index == (grounds.count - 1) ? .Boss : .Madeireiro
            let enemy = Enemy(manager: self,type: typeEnemy)
            guard let enemyNode = enemy.component(ofType: AnimatedSpriteComponent.self)?.spriteNode else { return }
            let ground = grounds[index]
            let groundNode = ground.component(ofType: GroundComponent.self)?.groundNode
            let maxRange = ((groundNode?.position.x)!) + ((groundNode?.size.width)!)/2
            let minRange = ((groundNode?.position.x)!) - ((groundNode?.size.width)!)/2
            
            enemy.maxRangeWalk = maxRange
            enemy.minRangeWalk = minRange
            
            enemyNode.position = positionBasedOnLastElement(lastNode: groundNode!,
                                                            presentNode: enemyNode,
                                                            dx: -100,
                                                            dy: enemyNode.size.height + groundNode!.size.height / 2 + 10)
            self.addEnemy(enemy)
        }
    }
    
    func addCoin(_ entity:GKEntity){
        coins.append(entity)
        
        if let spriteNode = entity.component(ofType: AnimatedSpriteComponent.self)?.spriteNode {
            scene.addChild(spriteNode)
        }
    }
    
    
    
    func updateEnemy(_ deltaTime:TimeInterval){
        for enemy in enemies{
            enemy.update(deltaTime: deltaTime)
        }
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
    
    func didUpdateLife(_ life:Int){
        self.lifeLabel.text = String.init(format: "%03d", life)
        switch life {
        case 51...100:
            heart.texture = SKTexture(imageNamed: "FullHeart")
        case 1...50:
            heart.texture = SKTexture(imageNamed: "HalfHeart")
        default:
            scene.notifyGameOver()
            heart.texture = SKTexture(imageNamed: "EmptyHeart")
        }
    }
    
}
