import Foundation
import SwiftData

@Model
final class SpendingCategory {
    @Attribute(.unique) var id: UUID
    var name: String
    var icon: String
    var iconColorHex: String
    var displayOrder: Int
    var isDefault: Bool
    var parentCategoryId: UUID?
    var createdAt: Date

    init(id: UUID = UUID(), name: String, icon: String, iconColorHex: String = "#007AFF", displayOrder: Int, isDefault: Bool = false, parentCategoryId: UUID? = nil, createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.icon = icon
        self.iconColorHex = iconColorHex
        self.displayOrder = displayOrder
        self.isDefault = isDefault
        self.parentCategoryId = parentCategoryId
        self.createdAt = createdAt
    }
}
