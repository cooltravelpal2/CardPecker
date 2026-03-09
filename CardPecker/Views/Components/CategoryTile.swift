import SwiftUI

struct CategoryTile: View {
    let category: SpendingCategory

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: category.icon)
                .font(.title)
                .foregroundStyle(.primary)
            Text(category.name)
                .font(.caption)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, minHeight: 80)
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
