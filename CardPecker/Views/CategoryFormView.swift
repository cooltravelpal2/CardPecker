import SwiftUI
import SwiftData

struct CategoryFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let category: SpendingCategory?

    @State private var name: String = ""
    @State private var icon: String = "star"
    @State private var iconColor: Color = .blue

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
                ColorPicker("Icon Color", selection: $iconColor)
            }

            Section("Icon") {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 44))], spacing: 12) {
                    ForEach(commonIcons, id: \.self) { iconName in
                        Button {
                            icon = iconName
                        } label: {
                            Image(systemName: iconName)
                                .font(.title2)
                                .foregroundStyle(icon == iconName ? iconColor : .secondary)
                                .frame(width: 44, height: 44)
                                .background(icon == iconName ? iconColor.opacity(0.15) : Color.clear)
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
                    Image(systemName: icon)
                        .foregroundStyle(iconColor)
                    Text(name.isEmpty ? "Category" : name)
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
                iconColor = Color(hex: category.iconColorHex)
            }
        }
    }

    private func save() {
        let colorHex = iconColor.toHex()

        if let category {
            category.name = name
            category.icon = icon
            category.iconColorHex = colorHex
        } else {
            let maxOrder = (try? modelContext.fetch(FetchDescriptor<SpendingCategory>()))?.map(\.displayOrder).max() ?? -1
            let newCategory = SpendingCategory(
                name: name,
                icon: icon,
                iconColorHex: colorHex,
                displayOrder: maxOrder + 1,
                isDefault: false
            )
            modelContext.insert(newCategory)
        }
        try? modelContext.save()
        dismiss()
    }
}
