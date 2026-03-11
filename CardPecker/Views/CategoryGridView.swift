import SwiftUI
import SwiftData

struct CategoryGridView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(LocalizationManager.self) private var loc
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
                        Label("empty.noCardsAdded".loc, systemImage: "creditcard")
                    } description: {
                        Text("empty.noCardsDescription".loc)
                    } actions: {
                        NavigationLink(destination: SettingsView()) {
                            Text("button.goToSettings".loc)
                        }
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(viewModel.categories) { category in
                                if viewModel.hasSubcategories(category) {
                                    NavigationLink(value: "sub:\(category.id.uuidString)") {
                                        CategoryTile(category: category, showChevron: true)
                                    }
                                    .buttonStyle(.plain)
                                } else {
                                    NavigationLink(value: "cat:\(category.id.uuidString)") {
                                        CategoryTile(category: category)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        .padding()
                    }
                }
            } else {
                ProgressView()
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gearshape")
                }
            }
        }
        .navigationDestination(for: String.self) { value in
            if value.hasPrefix("sub:") {
                let idStr = String(value.dropFirst(4))
                if let uuid = UUID(uuidString: idStr),
                   let parent = viewModel?.categories.first(where: { $0.id == uuid }) {
                    SubcategoryView(parent: parent)
                }
            } else if value.hasPrefix("cat:") {
                let idStr = String(value.dropFirst(4))
                if let uuid = UUID(uuidString: idStr),
                   let category = findCategory(uuid) {
                    RecommendationView(category: category)
                }
            }
        }
        .onAppear {
            if viewModel == nil {
                viewModel = CategoryViewModel(modelContext: modelContext)
            } else {
                viewModel?.refresh()
            }
        }
    }

    private func findCategory(_ id: UUID) -> SpendingCategory? {
        let descriptor = FetchDescriptor<SpendingCategory>()
        let all = (try? modelContext.fetch(descriptor)) ?? []
        return all.first(where: { $0.id == id })
    }
}
