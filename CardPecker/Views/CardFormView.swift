import SwiftUI
import SwiftData

struct CardFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let card: Card?

    @State private var name: String = ""
    @State private var rewardsCurrency: String = ""
    @State private var pointValueCents: String = "1.0"
    @State private var cardColorHex: String = ""
    @State private var selectedColor: Color = .blue
    @State private var useCustomColor: Bool = false
    @State private var multipliers: [UUID: String] = [:]

    @Query(sort: \SpendingCategory.displayOrder) private var allCategories: [SpendingCategory]

    private var categories: [SpendingCategory] {
        allCategories.filter { $0.parentCategoryId == nil }
    }

    private var isEditing: Bool { card != nil }

    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        (Double(pointValueCents) ?? 0) > 0
    }

    var body: some View {
        Form {
            Section("Card Details") {
                TextField("Card Name", text: $name)
                TextField("Rewards Currency (e.g., Ultimate Rewards)", text: $rewardsCurrency)
                TextField("Point Value (cents per point)", text: $pointValueCents)
                    .keyboardType(.decimalPad)

                Toggle("Custom Color", isOn: $useCustomColor)
                if useCustomColor {
                    ColorPicker("Card Color", selection: $selectedColor)
                }
            }

            Section("Category Multipliers") {
                ForEach(categories) { category in
                    HStack {
                        Label(category.name, systemImage: category.icon)
                        Spacer()
                        TextField("1.0", text: multiplierBinding(for: category.id))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 60)
                            .onTapGesture {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    UIApplication.shared.sendAction(#selector(UIResponder.selectAll(_:)), to: nil, from: nil, for: nil)
                                }
                            }
                    }
                }
            }
        }
        .navigationTitle(isEditing ? "Edit Card" : "Add Card")
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
        .onAppear { loadCardData() }
    }

    private func multiplierBinding(for categoryId: UUID) -> Binding<String> {
        Binding(
            get: { multipliers[categoryId] ?? "1.0" },
            set: { multipliers[categoryId] = $0 }
        )
    }

    private func loadCardData() {
        guard let card else { return }
        name = card.name
        rewardsCurrency = card.rewardsCurrency
        pointValueCents = String(card.pointValueCents)
        if let hex = card.cardColorHex {
            cardColorHex = hex
            selectedColor = Color(hex: hex)
            useCustomColor = true
        }
        for cm in card.categoryMultipliers {
            multipliers[cm.categoryId] = String(cm.multiplier)
        }
    }

    private func save() {
        let parsedMultipliers: [UUID: Double] = multipliers.reduce(into: [:]) { result, pair in
            if let value = Double(pair.value) {
                result[pair.key] = value
            }
        }

        let colorHex: String? = useCustomColor ? selectedColor.toHex() : nil
        let pointValue = Double(pointValueCents) ?? 1.0

        let vm = CardManagementViewModel(modelContext: modelContext)

        if let card {
            vm.updateCard(card, name: name, rewardsCurrency: rewardsCurrency, pointValueCents: pointValue, cardColorHex: colorHex, multipliers: parsedMultipliers)
        } else {
            vm.addCard(name: name, rewardsCurrency: rewardsCurrency, pointValueCents: pointValue, cardColorHex: colorHex, multipliers: parsedMultipliers)
        }

        dismiss()
    }
}

extension Color {
    func toHex() -> String {
        guard let components = UIColor(self).cgColor.components, components.count >= 3 else {
            return "#000000"
        }
        let r = Int(components[0] * 255)
        let g = Int(components[1] * 255)
        let b = Int(components[2] * 255)
        return String(format: "#%02X%02X%02X", r, g, b)
    }
}
