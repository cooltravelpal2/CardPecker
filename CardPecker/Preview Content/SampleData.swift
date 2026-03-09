import Foundation
import SwiftData

@MainActor
let sampleContainer: ModelContainer = {
    let schema = Schema([Card.self, SpendingCategory.self, CategoryMultiplier.self])
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: schema, configurations: config)
    let context = container.mainContext

    // Seed default categories and cards using the same logic as the app
    DefaultCategories.seedIfNeeded(context: context)
    DefaultCards.seedIfNeeded(context: context)

    return container
}()
