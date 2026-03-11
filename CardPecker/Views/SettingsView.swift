import SwiftUI

struct SettingsView: View {
    @Environment(LocalizationManager.self) private var loc

    var body: some View {
        @Bindable var loc = loc
        List {
            NavigationLink {
                MyCardsView()
            } label: {
                Label("settings.myCards".loc, systemImage: "creditcard")
            }

            NavigationLink {
                MyCategoriesView()
            } label: {
                Label("settings.myCategories".loc, systemImage: "square.grid.2x2")
            }

            Section("settings.languageSection".loc) {
                ForEach(AppLanguage.allCases, id: \.self) { language in
                    Button {
                        loc.currentLanguage = language
                    } label: {
                        HStack {
                            Text(language.displayName)
                                .foregroundStyle(.primary)
                            Spacer()
                            if loc.currentLanguage == language {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.blue)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("nav.settings".loc)
    }
}
