import GameplayKit

class Plataform: GKEntity {

    override init() {
        super.init()
        self.addComponent(PlataformComponent())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
