import SwiftUI
import SwiftData

struct RecommendationView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: RecommendationViewModel?
    let category: SpendingCategory

    var body: some View {
        Group {
            if let viewModel {
                if viewModel.hasNoCards {
                    ContentUnavailableView {
                        Label("No Cards", systemImage: "creditcard")
                    } description: {
                        Text("Add cards in Settings to see recommendations.")
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            if let best = viewModel.bestCard {
                                HeroCardView(recommendation: best)
                            }

                            if !viewModel.otherCards.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Other Cards")
                                        .font(.headline)
                                        .foregroundStyle(.secondary)

                                    ForEach(viewModel.otherCards) { rec in
                                        CardRecommendationRow(recommendation: rec)
                                        Divider()
                                    }
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
        .navigationTitle(category.name)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Label(category.name, systemImage: category.icon)
                    .font(.headline)
            }
        }
        .onAppear {
            if viewModel == nil {
                viewModel = RecommendationViewModel(category: category, modelContext: modelContext)
            } else {
                viewModel?.loadRecommendations()
            }
        }
    }
}
