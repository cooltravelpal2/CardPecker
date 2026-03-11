import SwiftUI

struct CardTemplateSelectionView: View {
    let bank: BankInfo
    let onSelectTemplate: (CardTemplate?) -> Void

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

            Section("addCard.selectCard".loc) {
                ForEach(bank.cards) { card in
                    Button {
                        onSelectTemplate(card)
                    } label: {
                        HStack {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color(hex: card.colorHex))
                                .frame(width: 40, height: 28)
                                .overlay {
                                    Image(systemName: "creditcard")
                                        .font(.system(size: 12))
                                        .foregroundStyle(.white)
                                }
                            VStack(alignment: .leading, spacing: 2) {
                                Text(card.name)
                                    .font(.body)
                                    .foregroundStyle(.primary)
                                Text("\(card.currency) · \(card.pointValue, specifier: "%.2f")¢/pt")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(bank.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
