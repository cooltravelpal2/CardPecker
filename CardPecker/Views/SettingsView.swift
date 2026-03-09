import SwiftUI

struct SettingsView: View {
    var body: some View {
        List {
            NavigationLink {
                MyCardsView()
            } label: {
                Label("My Cards", systemImage: "creditcard")
            }

            NavigationLink {
                MyCategoriesView()
            } label: {
                Label("My Categories", systemImage: "square.grid.2x2")
            }
        }
        .navigationTitle("Settings")
    }
}
