import Foundation
import SwiftData
import SwiftUI

@Observable
final class CategoryViewModel {
    private var modelContext: ModelContext

    var categories: [SpendingCategory] = []
    var cardCount: Int = 0

    var hasNoCards: Bool { cardCount == 0 }

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        DefaultCategories.seedIfNeeded(context: modelContext)
        fetchCategories()
        fetchCardCount()
    }

    func fetchCategories() {
        var descriptor = FetchDescriptor<SpendingCategory>(
            sortBy: [SortDescriptor(\.displayOrder)]
        )
        categories = (try? modelContext.fetch(descriptor)) ?? []
    }

    func fetchCardCount() {
        let descriptor = FetchDescriptor<Card>()
        cardCount = (try? modelContext.fetchCount(descriptor)) ?? 0
    }

    func refresh() {
        fetchCategories()
        fetchCardCount()
    }
}
