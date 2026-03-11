import SwiftUI

struct CategoryTile: View {
    let category: SpendingCategory
    var showChevron: Bool = false

    private var tileColor: Color {
        Color(hex: category.iconColorHex)
    }

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: category.icon)
                .font(.system(size: 32))
                .foregroundStyle(tileColor)
            HStack(spacing: 2) {
                Text(category.name)
                    .font(.caption)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .foregroundStyle(.primary)
                if showChevron {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity, minHeight: 70)
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(tileColor.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(tileColor.opacity(0.2), lineWidth: 1)
        )
    }
}
