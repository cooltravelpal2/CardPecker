import Foundation

struct CardRecommendation: Identifiable {
    let id = UUID()
    let card: Card
    let multiplier: Double
    let pointValueCents: Double
    let effectiveReturnPercent: Double
}

enum RewardsCalculator {
    static func recommend(for categoryId: UUID, cards: [Card]) -> [CardRecommendation] {
        cards.map { card in
            let multiplier = card.categoryMultipliers
                .first(where: { $0.categoryId == categoryId })?
                .multiplier ?? 1.0
            let effectiveReturn = multiplier * card.pointValueCents
            return CardRecommendation(
                card: card,
                multiplier: multiplier,
                pointValueCents: card.pointValueCents,
                effectiveReturnPercent: effectiveReturn
            )
        }
        .sorted {
            if $0.effectiveReturnPercent != $1.effectiveReturnPercent {
                return $0.effectiveReturnPercent > $1.effectiveReturnPercent
            }
            return $0.card.name < $1.card.name
        }
    }
}
