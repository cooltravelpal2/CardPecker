import Foundation
import SwiftData

@MainActor
let sampleContainer: ModelContainer = {
    let schema = Schema([Card.self, SpendingCategory.self, CategoryMultiplier.self])
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: schema, configurations: config)
    let context = container.mainContext

    // Seed categories
    let hotel = SpendingCategory(name: "Hotel", icon: "bed.double", displayOrder: 0, isDefault: true)
    let dining = SpendingCategory(name: "Dining", icon: "fork.knife", displayOrder: 1, isDefault: true)
    let grocery = SpendingCategory(name: "Grocery", icon: "cart", displayOrder: 2, isDefault: true)
    let shopping = SpendingCategory(name: "Shopping", icon: "bag", displayOrder: 3, isDefault: true)
    let airline = SpendingCategory(name: "Airline", icon: "airplane", displayOrder: 4, isDefault: true)
    let gas = SpendingCategory(name: "Gas", icon: "fuelpump", displayOrder: 5, isDefault: true)
    let rental = SpendingCategory(name: "Rental", icon: "car", displayOrder: 6, isDefault: true)
    let foreign = SpendingCategory(name: "Foreign Transactions", icon: "globe", displayOrder: 7, isDefault: true)

    [hotel, dining, grocery, shopping, airline, gas, rental, foreign].forEach { context.insert($0) }

    // Chase Sapphire Reserve
    let csr = Card(name: "Chase Sapphire Reserve", rewardsCurrency: "Ultimate Rewards", pointValueCents: 1.5, cardColorHex: "#003087")
    context.insert(csr)
    let csrMultipliers: [(SpendingCategory, Double)] = [
        (hotel, 10.0), (dining, 3.0), (airline, 5.0), (rental, 10.0),
    ]
    for (cat, mult) in csrMultipliers {
        let cm = CategoryMultiplier(categoryId: cat.id, multiplier: mult)
        cm.card = csr
        context.insert(cm)
    }

    // Amex Gold
    let amexGold = Card(name: "Amex Gold", rewardsCurrency: "Membership Rewards", pointValueCents: 1.0, cardColorHex: "#B5985A")
    context.insert(amexGold)
    let agMultipliers: [(SpendingCategory, Double)] = [
        (dining, 4.0), (grocery, 4.0), (airline, 3.0),
    ]
    for (cat, mult) in agMultipliers {
        let cm = CategoryMultiplier(categoryId: cat.id, multiplier: mult)
        cm.card = amexGold
        context.insert(cm)
    }

    // Citi Double Cash
    let citiDC = Card(name: "Citi Double Cash", rewardsCurrency: "ThankYou Points", pointValueCents: 1.0)
    context.insert(citiDC)
    // Base 2x on everything — stored as multiplier 2.0 for all categories
    for cat in [hotel, dining, grocery, shopping, airline, gas, rental, foreign] {
        let cm = CategoryMultiplier(categoryId: cat.id, multiplier: 2.0)
        cm.card = citiDC
        context.insert(cm)
    }

    return container
}()
