import SwiftUI

struct CategoryTile: View {
    let category: SpendingCategory
    var showChevron: Bool = false

    private var tileColor: Color {
        Color(hex: category.iconColorHex)
    }

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(tileColor.opacity(0.15))
                    .frame(width: 48, height: 48)
                Image(systemName: category.icon)
                    .font(.title2)
                    .foregroundStyle(tileColor)
            }
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
        .frame(maxWidth: .infinity, minHeight: 90)
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.background)
                .shadow(color: tileColor.opacity(0.15), radius: 4, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(tileColor.opacity(0.2), lineWidth: 1)
        )
    }
}
