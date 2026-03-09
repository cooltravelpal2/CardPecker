import Foundation
import SwiftData

@Model
final class SpendingCategory {
    @Attribute(.unique) var id: UUID
    var name: String
    var icon: String
    var displayOrder: Int
    var isDefault: Bool
    var createdAt: Date

    init(id: UUID = UUID(), name: String, icon: String, displayOrder: Int, isDefault: Bool = false, createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.icon = icon
        self.displayOrder = displayOrder
        self.isDefault = isDefault
        self.createdAt = createdAt
    }
}
