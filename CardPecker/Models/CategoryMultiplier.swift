import Foundation
import SwiftData

@Model
final class CategoryMultiplier {
    @Attribute(.unique) var id: UUID
    var categoryId: UUID
    var multiplier: Double
    var card: Card?

    init(id: UUID = UUID(), categoryId: UUID, multiplier: Double = 1.0) {
        self.id = id
        self.categoryId = categoryId
        self.multiplier = multiplier
    }
}
