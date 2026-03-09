import Foundation
import SwiftData

@Model
final class Card {
    @Attribute(.unique) var id: UUID
    var name: String
    var rewardsCurrency: String
    var pointValueCents: Double
    var cardColorHex: String?
    @Relationship(deleteRule: .cascade, inverse: \CategoryMultiplier.card)
    var categoryMultipliers: [CategoryMultiplier]
    var createdAt: Date

    init(id: UUID = UUID(), name: String, rewardsCurrency: String = "", pointValueCents: Double = 1.0, cardColorHex: String? = nil, categoryMultipliers: [CategoryMultiplier] = [], createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.rewardsCurrency = rewardsCurrency
        self.pointValueCents = pointValueCents
        self.cardColorHex = cardColorHex
        self.categoryMultipliers = categoryMultipliers
        self.createdAt = createdAt
    }
}
