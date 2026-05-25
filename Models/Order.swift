import Foundation

enum OrderSide: String {
    case buy, sell
}

enum OrderType: String, CaseIterable, Identifiable {
    case market, limit, stopLoss

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .market:   return "Market"
        case .limit:    return "Limit"
        case .stopLoss: return "Stop Loss"
        }
    }
}

enum OrderStatus {
    case open, filled, cancelled
}

struct Order: Identifiable {
    let id:        String
    let symbol:    String
    let side:      OrderSide
    let type:      OrderType
    let quantity:  Double
    let price:     Double
    var status:    OrderStatus
    let createdAt: Date

    var total: Double { quantity * price }
}
