import GameplayKit

class Ground: GKEntity {

    init(size: CGSize) {
        super.init()
        self.addComponent(GroundComponent(size: size))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
