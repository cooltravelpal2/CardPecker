import SwiftUI

struct CardRecommendationRow: View {
    let recommendation: CardRecommendation

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(recommendation.card.name)
                    .font(.headline)
                HStack(spacing: 12) {
                    Text("\(recommendation.multiplier, specifier: "%.1f")x")
                    Text("\(recommendation.pointValueCents, specifier: "%.1f")¢/pt")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            Spacer()
            Text("\(recommendation.effectiveReturnPercent, specifier: "%.1f")%")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.blue)
        }
        .padding(.vertical, 4)
    }
}
