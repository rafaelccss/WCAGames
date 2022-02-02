import GameplayKit

class Ground: GKEntity {

    override init() {
        super.init()
        self.addComponent(GroundComponent())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
