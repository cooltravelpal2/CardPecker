import SwiftUI
import SwiftData

struct CategoryGridView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: CategoryViewModel?

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        Group {
            if let viewModel {
                if viewModel.hasNoCards {
                    ContentUnavailableView {
                        Label("No Cards Added", systemImage: "creditcard")
                    } description: {
                        Text("Add your credit cards in Settings to get recommendations.")
                    } actions: {
                        NavigationLink(destination: SettingsView()) {
                            Text("Go to Settings")
                        }
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(viewModel.categories) { category in
                                NavigationLink(value: category) {
                                    CategoryTile(category: category)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding()
                    }
                }
            } else {
                ProgressView()
            }
        }
        .navigationTitle("CardPecker")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gearshape")
                }
            }
        }
        .navigationDestination(for: SpendingCategory.self) { category in
            RecommendationView(category: category)
        }
        .onAppear {
            if viewModel == nil {
                viewModel = CategoryViewModel(modelContext: modelContext)
            } else {
                viewModel?.refresh()
            }
        }
    }
}
