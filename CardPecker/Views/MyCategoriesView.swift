import SwiftUI
import SwiftData

struct MyCategoriesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SpendingCategory.displayOrder) private var categories: [SpendingCategory]
    @State private var showingAddCategory = false
    @State private var categoryToDelete: SpendingCategory?

    var body: some View {
        List {
            ForEach(categories) { category in
                NavigationLink {
                    CategoryFormView(category: category)
                } label: {
                    Label(category.name, systemImage: category.icon)
                }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        categoryToDelete = category
                    } label: {
                        Label("button.delete".loc, systemImage: "trash")
                    }
                }
            }
        }
        .navigationTitle("nav.myCategories".loc)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingAddCategory = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddCategory) {
            NavigationStack {
                CategoryFormView(category: nil)
            }
        }
        .alert("alert.deleteCategory".loc, isPresented: Binding(
            get: { categoryToDelete != nil },
            set: { if !$0 { categoryToDelete = nil } }
        )) {
            Button("button.cancel".loc, role: .cancel) { categoryToDelete = nil }
            Button("button.delete".loc, role: .destructive) {
                if let category = categoryToDelete {
                    modelContext.delete(category)
                    try? modelContext.save()
                    categoryToDelete = nil
                }
            }
        } message: {
            if let cat = categoryToDelete, cat.isDefault {
                Text("alert.deleteCategoryDefault".loc(cat.name))
            } else {
                Text("alert.deleteCategoryMessage".loc(categoryToDelete?.name ?? ""))
            }
        }
    }
}
