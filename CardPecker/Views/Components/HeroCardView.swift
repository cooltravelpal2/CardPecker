import SwiftUI

struct HeroCardView: View {
    let recommendation: CardRecommendation

    private var accentColor: Color {
        if let hex = recommendation.card.cardColorHex {
            return Color(hex: hex)
        }
        return .blue
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "trophy.fill")
                    .foregroundStyle(.yellow)
                Text("Best Card")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
            }

            Text(recommendation.card.name)
                .font(.title2)
                .fontWeight(.bold)

            HStack(spacing: 16) {
                Label("\(recommendation.multiplier, specifier: "%.1f")x pts", systemImage: "star.fill")
                Label("\(recommendation.pointValueCents, specifier: "%.1f")¢/pt", systemImage: "dollarsign.circle")
                Label("\(recommendation.effectiveReturnPercent, specifier: "%.1f")%", systemImage: "percent")
                    .fontWeight(.semibold)
            }
            .font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(accentColor.opacity(0.1))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(accentColor.opacity(0.3), lineWidth: 2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
