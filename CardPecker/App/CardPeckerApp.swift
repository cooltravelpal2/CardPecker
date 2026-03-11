import SwiftUI
import SwiftData

@main
struct CardPeckerApp: App {
    @State private var locManager = LocalizationManager.shared

    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationStack {
                    CategoryGridView()
                }
                .tabItem {
                    Label("tab.whichCard".loc, systemImage: "creditcard")
                }

                NavigationStack {
                    CouponBookView()
                }
                .tabItem {
                    Label("tab.couponBook".loc, systemImage: "ticket")
                }
            }
            .environment(locManager)
        }
        .modelContainer(for: [Card.self, SpendingCategory.self, CategoryMultiplier.self])
    }
}
