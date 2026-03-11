import Foundation

struct CardTemplate: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let currency: String
    let pointValue: Double
    let colorHex: String
    let multipliers: [String: Double]

    func hash(into hasher: inout Hasher) { hasher.combine(name) }
    static func == (lhs: CardTemplate, rhs: CardTemplate) -> Bool { lhs.name == rhs.name }
}

struct BankInfo: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let colorHex: String
    let cards: [CardTemplate]

    func hash(into hasher: inout Hasher) { hasher.combine(name) }
    static func == (lhs: BankInfo, rhs: BankInfo) -> Bool { lhs.name == rhs.name }
}

enum CardTemplates {
    static let banks: [BankInfo] = [
        // MARK: - Chase
        BankInfo(name: "Chase", colorHex: "#003087", cards: [
            CardTemplate(
                name: "Chase Sapphire Reserve",
                currency: "Chase Ultimate Rewards",
                pointValue: 2.05,
                colorHex: "#003087",
                multipliers: ["Hotel": 10, "Dining": 3, "Airline": 5, "Rental": 10]
            ),
            CardTemplate(
                name: "Chase Sapphire Preferred",
                currency: "Chase Ultimate Rewards",
                pointValue: 2.05,
                colorHex: "#1A3C6E",
                multipliers: ["Hotel": 5, "Dining": 3, "Airline": 5, "Grocery": 3, "Rental": 5]
            ),
            CardTemplate(
                name: "Chase Freedom Unlimited",
                currency: "Chase Ultimate Rewards",
                pointValue: 2.05,
                colorHex: "#0A5CA8",
                multipliers: ["Dining": 3, "Grocery": 3]
            ),
            CardTemplate(
                name: "Chase Freedom Flex",
                currency: "Chase Ultimate Rewards",
                pointValue: 2.05,
                colorHex: "#0078C1",
                multipliers: ["Dining": 3, "Grocery": 3]
            ),
            CardTemplate(
                name: "Chase Ink Business Preferred",
                currency: "Chase Ultimate Rewards",
                pointValue: 2.05,
                colorHex: "#1C2340",
                multipliers: ["Airline": 3, "Hotel": 3, "Shopping": 3]
            ),
        ]),

        // MARK: - American Express
        BankInfo(name: "American Express", colorHex: "#006FCF", cards: [
            CardTemplate(
                name: "AMEX Platinum",
                currency: "Amex Membership Rewards",
                pointValue: 2.0,
                colorHex: "#A5A7AA",
                multipliers: ["Airline": 5, "Hotel": 5]
            ),
            CardTemplate(
                name: "AMEX Gold",
                currency: "Amex Membership Rewards",
                pointValue: 2.0,
                colorHex: "#B5985A",
                multipliers: ["Dining": 4, "Grocery": 4, "Airline": 3]
            ),
            CardTemplate(
                name: "AMEX Green",
                currency: "Amex Membership Rewards",
                pointValue: 2.0,
                colorHex: "#2E7D32",
                multipliers: ["Dining": 3, "Airline": 3, "Hotel": 3]
            ),
            CardTemplate(
                name: "AMEX Blue Cash Preferred",
                currency: "Cash Back",
                pointValue: 1.0,
                colorHex: "#006FCF",
                multipliers: ["Grocery": 6, "Gas": 3]
            ),
            CardTemplate(
                name: "AMEX Blue Cash Everyday",
                currency: "Cash Back",
                pointValue: 1.0,
                colorHex: "#0077C8",
                multipliers: ["Grocery": 3, "Gas": 3, "Shopping": 3]
            ),
            CardTemplate(
                name: "AMEX Business Platinum",
                currency: "Amex Membership Rewards",
                pointValue: 2.0,
                colorHex: "#8C8C8C",
                multipliers: ["Airline": 5, "Hotel": 5]
            ),
            CardTemplate(
                name: "AMEX Business Gold",
                currency: "Amex Membership Rewards",
                pointValue: 2.0,
                colorHex: "#C9A84C",
                multipliers: ["Airline": 4, "Gas": 4, "Dining": 4, "Shopping": 4]
            ),
        ]),

        // MARK: - Capital One
        BankInfo(name: "Capital One", colorHex: "#004977", cards: [
            CardTemplate(
                name: "Capital One Venture X",
                currency: "Capital One Miles",
                pointValue: 1.85,
                colorHex: "#004977",
                multipliers: ["Hotel": 10, "Rental": 10, "Airline": 5, "Dining": 2, "Grocery": 2, "Shopping": 2, "Gas": 2, "Foreign Transactions": 2]
            ),
            CardTemplate(
                name: "Capital One Venture",
                currency: "Capital One Miles",
                pointValue: 1.85,
                colorHex: "#1A6B9C",
                multipliers: ["Hotel": 5, "Dining": 2, "Grocery": 2, "Shopping": 2, "Airline": 2, "Gas": 2, "Rental": 2, "Foreign Transactions": 2]
            ),
            CardTemplate(
                name: "Capital One SavorOne",
                currency: "Cash Back",
                pointValue: 1.0,
                colorHex: "#2D8C4E",
                multipliers: ["Dining": 3, "Grocery": 3]
            ),
            CardTemplate(
                name: "Capital One Savor",
                currency: "Cash Back",
                pointValue: 1.0,
                colorHex: "#1A6B3C",
                multipliers: ["Dining": 4, "Grocery": 4]
            ),
            CardTemplate(
                name: "Capital One Quicksilver",
                currency: "Cash Back",
                pointValue: 1.0,
                colorHex: "#5A6B7A",
                multipliers: [:]
            ),
        ]),

        // MARK: - Citi
        BankInfo(name: "Citi", colorHex: "#003DA5", cards: [
            CardTemplate(
                name: "Citi Strata Premier",
                currency: "Citi ThankYou Points",
                pointValue: 1.9,
                colorHex: "#003DA5",
                multipliers: ["Hotel": 3, "Dining": 3, "Grocery": 3, "Airline": 3, "Gas": 3]
            ),
            CardTemplate(
                name: "Citi Double Cash",
                currency: "Citi ThankYou Points",
                pointValue: 1.9,
                colorHex: "#1A5BC4",
                multipliers: ["Hotel": 2, "Dining": 2, "Grocery": 2, "Shopping": 2, "Airline": 2, "Gas": 2, "Rental": 2, "Foreign Transactions": 2]
            ),
            CardTemplate(
                name: "Citi Custom Cash",
                currency: "Citi ThankYou Points",
                pointValue: 1.9,
                colorHex: "#4A90D9",
                multipliers: [:]
            ),
        ]),

        // MARK: - Bank of America
        BankInfo(name: "Bank of America", colorHex: "#DC1431", cards: [
            CardTemplate(
                name: "BofA Premium Rewards",
                currency: "Cash Back",
                pointValue: 1.0,
                colorHex: "#DC1431",
                multipliers: ["Dining": 3.5, "Airline": 3.5, "Hotel": 3.5]
            ),
            CardTemplate(
                name: "BofA Customized Cash",
                currency: "Cash Back",
                pointValue: 1.0,
                colorHex: "#B71C1C",
                multipliers: [:]
            ),
            CardTemplate(
                name: "BofA Unlimited Cash",
                currency: "Cash Back",
                pointValue: 1.0,
                colorHex: "#E53935",
                multipliers: [:]
            ),
        ]),

        // MARK: - Wells Fargo
        BankInfo(name: "Wells Fargo", colorHex: "#D71E28", cards: [
            CardTemplate(
                name: "Wells Fargo Autograph Journey",
                currency: "Cash Back",
                pointValue: 1.0,
                colorHex: "#D71E28",
                multipliers: ["Hotel": 5, "Airline": 4, "Dining": 3, "Rental": 4]
            ),
            CardTemplate(
                name: "Wells Fargo Autograph",
                currency: "Cash Back",
                pointValue: 1.0,
                colorHex: "#B71C1C",
                multipliers: ["Dining": 3, "Airline": 3, "Gas": 3, "Hotel": 3, "Rental": 3]
            ),
            CardTemplate(
                name: "Wells Fargo Active Cash",
                currency: "Cash Back",
                pointValue: 1.0,
                colorHex: "#FF5252",
                multipliers: ["Hotel": 2, "Dining": 2, "Grocery": 2, "Shopping": 2, "Airline": 2, "Gas": 2, "Rental": 2, "Foreign Transactions": 2]
            ),
        ]),

        // MARK: - US Bank
        BankInfo(name: "US Bank", colorHex: "#002663", cards: [
            CardTemplate(
                name: "US Bank Altitude Reserve",
                currency: "US Bank Points",
                pointValue: 1.5,
                colorHex: "#002663",
                multipliers: ["Dining": 3, "Airline": 3, "Hotel": 3]
            ),
            CardTemplate(
                name: "US Bank Altitude Go",
                currency: "US Bank Points",
                pointValue: 1.5,
                colorHex: "#1A4B8C",
                multipliers: ["Dining": 4, "Grocery": 2]
            ),
        ]),

        // MARK: - Discover
        BankInfo(name: "Discover", colorHex: "#FF6600", cards: [
            CardTemplate(
                name: "Discover it Cash Back",
                currency: "Cash Back",
                pointValue: 1.0,
                colorHex: "#FF6600",
                multipliers: [:]
            ),
            CardTemplate(
                name: "Discover it Miles",
                currency: "Cash Back",
                pointValue: 1.0,
                colorHex: "#CC5200",
                multipliers: [:]
            ),
        ]),

        // MARK: - Bilt
        BankInfo(name: "Bilt", colorHex: "#000000", cards: [
            CardTemplate(
                name: "Bilt Mastercard",
                currency: "Bilt Points",
                pointValue: 2.05,
                colorHex: "#000000",
                multipliers: ["Dining": 3, "Airline": 2, "Hotel": 2]
            ),
        ]),
    ]

    static var allBankNames: [String] {
        banks.map(\.name)
    }

    static func bank(named name: String) -> BankInfo? {
        banks.first(where: { $0.name == name })
    }
}
