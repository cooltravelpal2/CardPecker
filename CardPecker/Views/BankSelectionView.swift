import SwiftUI

struct BankSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    let onSelectTemplate: (CardTemplate?) -> Void

    @State private var searchText = ""

    private var filteredBanks: [BankInfo] {
        if searchText.isEmpty {
            return CardTemplates.banks
        }
        return CardTemplates.banks.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        List {
            Section {
                Button {
                    onSelectTemplate(nil)
                } label: {
                    Label("addCard.customCard".loc, systemImage: "plus.rectangle")
                        .font(.headline)
                }
            }

            Section("addCard.selectBank".loc) {
                ForEach(filteredBanks) { bank in
                    NavigationLink {
                        CardTemplateSelectionView(bank: bank, onSelectTemplate: onSelectTemplate)
                    } label: {
                        HStack {
                            Circle()
                                .fill(Color(hex: bank.colorHex))
                                .frame(width: 32, height: 32)
                                .overlay {
                                    Text(String(bank.name.prefix(1)))
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundStyle(.white)
                                }
                            Text(bank.name)
                                .font(.body)
                        }
                    }
                }
            }
        }
        .searchable(text: $searchText, prompt: "addCard.searchBanks".loc)
        .navigationTitle("addCard.chooseBank".loc)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("button.cancel".loc) { dismiss() }
            }
        }
    }
}
