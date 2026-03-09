import SwiftUI
import SwiftData

struct CategoryFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let category: SpendingCategory?

    @State private var name: String = ""
    @State private var icon: String = "star"

    private var isEditing: Bool { category != nil }

    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private let commonIcons = [
        "star", "fork.knife", "cart", "bag", "airplane",
        "fuelpump", "car", "globe", "bed.double", "tram",
        "cross.vial", "hammer", "tv", "creditcard", "house",
        "phone", "laptopcomputer", "gift", "heart", "leaf",
    ]

    var body: some View {
        Form {
            Section("Category Details") {
                TextField("Category Name", text: $name)
            }

            Section("Icon") {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 44))], spacing: 12) {
                    ForEach(commonIcons, id: \.self) { iconName in
                        Button {
                            icon = iconName
                        } label: {
                            Image(systemName: iconName)
                                .font(.title2)
                                .frame(width: 44, height: 44)
                                .background(icon == iconName ? Color.accentColor.opacity(0.2) : Color.clear)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(.plain)
                    }
                }

                HStack {
                    Text("Custom SF Symbol:")
                    TextField("symbol.name", text: $icon)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
            }

            Section {
                HStack {
                    Text("Preview:")
                    Label(name.isEmpty ? "Category" : name, systemImage: icon)
                }
            }
        }
        .navigationTitle(isEditing ? "Edit Category" : "Add Category")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { save() }
                    .disabled(!isValid)
            }
        }
        .onAppear {
            if let category {
                name = category.name
                icon = category.icon
            }
        }
    }

    private func save() {
        if let category {
            category.name = name
            category.icon = icon
        } else {
            let maxOrder = (try? modelContext.fetch(FetchDescriptor<SpendingCategory>()))?.map(\.displayOrder).max() ?? -1
            let newCategory = SpendingCategory(
                name: name,
                icon: icon,
                displayOrder: maxOrder + 1,
                isDefault: false
            )
            modelContext.insert(newCategory)
        }
        try? modelContext.save()
        dismiss()
    }
}
