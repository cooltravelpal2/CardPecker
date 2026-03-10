import SwiftUI
import SwiftData

struct SubcategoryView: View {
    @Environment(\.modelContext) private var modelContext
    let parent: SpendingCategory

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    private var subcategories: [SpendingCategory] {
        let parentId = parent.id
        var descriptor = FetchDescriptor<SpendingCategory>(
            predicate: #Predicate { $0.parentCategoryId == parentId },
            sortBy: [SortDescriptor(\.displayOrder)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(subcategories) { sub in
                    NavigationLink {
                        RecommendationView(category: sub)
                    } label: {
                        CategoryTile(category: sub)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .navigationTitle(parent.name)
    }
}
