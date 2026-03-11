import Foundation
import SwiftUI

enum AppLanguage: String, CaseIterable {
    case english = "en"
    case chinese = "zh-Hans"

    var displayName: String {
        switch self {
        case .english: return "English"
        case .chinese: return "中文"
        }
    }
}

@Observable
final class LocalizationManager {
    static let shared = LocalizationManager()

    var currentLanguage: AppLanguage {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: "appLanguage")
            bundle = Self.bundle(for: currentLanguage)
        }
    }

    private(set) var bundle: Bundle

    private init() {
        let saved = UserDefaults.standard.string(forKey: "appLanguage") ?? "en"
        let lang = AppLanguage(rawValue: saved) ?? .english
        self.currentLanguage = lang
        self.bundle = Self.bundle(for: lang)
    }

    private static func bundle(for language: AppLanguage) -> Bundle {
        guard let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return Bundle.main
        }
        return bundle
    }

    func localized(_ key: String) -> String {
        bundle.localizedString(forKey: key, value: nil, table: nil)
    }

    func localized(_ key: String, _ args: CVarArg...) -> String {
        let format = bundle.localizedString(forKey: key, value: nil, table: nil)
        return String(format: format, arguments: args)
    }
}

extension String {
    var loc: String {
        LocalizationManager.shared.localized(self)
    }

    func loc(_ args: CVarArg...) -> String {
        let format = LocalizationManager.shared.bundle.localizedString(forKey: self, value: nil, table: nil)
        return String(format: format, arguments: args)
    }
}
