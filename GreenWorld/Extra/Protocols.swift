import Foundation
import GameplayKit

protocol ContactNotifiable {
    func contactDidBegin(with entity: GKEntity,_ manager: EntityManager)
}
