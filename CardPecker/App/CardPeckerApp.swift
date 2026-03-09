import SwiftUI
import SwiftData

@main
struct CardPeckerApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                CategoryGridView()
            }
        }
        .modelContainer(for: [Card.self, SpendingCategory.self, CategoryMultiplier.self])
    }
}
