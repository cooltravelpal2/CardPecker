import SwiftUI
import SwiftData

struct MyCardsView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: CardManagementViewModel?
    @State private var showingAddCard = false
    @State private var cardToDelete: Card?

    var body: some View {
        Group {
            if let viewModel {
                if viewModel.cards.isEmpty {
                    ContentUnavailableView {
                        Label("No Cards", systemImage: "creditcard")
                    } description: {
                        Text("Tap + to add your first credit card.")
                    }
                } else {
                    List {
                        ForEach(viewModel.cards) { card in
                            NavigationLink {
                                CardFormView(card: card)
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(card.name)
                                        .font(.headline)
                                    Text("\(card.pointValueCents, specifier: "%.1f")¢ per point")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    cardToDelete = card
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
            } else {
                ProgressView()
            }
        }
        .navigationTitle("My Cards")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingAddCard = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddCard) {
            NavigationStack {
                CardFormView(card: nil)
            }
            .onDisappear { viewModel?.fetchCards() }
        }
        .alert("Delete Card", isPresented: Binding(
            get: { cardToDelete != nil },
            set: { if !$0 { cardToDelete = nil } }
        )) {
            Button("Cancel", role: .cancel) { cardToDelete = nil }
            Button("Delete", role: .destructive) {
                if let card = cardToDelete {
                    viewModel?.deleteCard(card)
                    cardToDelete = nil
                }
            }
        } message: {
            Text("Are you sure you want to delete \(cardToDelete?.name ?? "this card")?")
        }
        .onAppear {
            if viewModel == nil {
                viewModel = CardManagementViewModel(modelContext: modelContext)
            } else {
                viewModel?.fetchCards()
            }
        }
    }
}
