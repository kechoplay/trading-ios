import SwiftUI

struct Asset: Identifiable, Equatable, Hashable {
    var id: String { symbol }

    let symbol:    String
    let name:      String
    var price:     Double
    var change:    Double
    let volume:    Double
    let marketCap: Double
    let market:    String
    let iconHex:   String

    var isGain:    Bool  { change >= 0 }
    var iconColor: Color { Color(hex: iconHex) }

    var tradingViewSymbol: String {
        switch market {
        case "Crypto":
            return "BINANCE:\(symbol)USDT"
        case "Stocks":
            return "NASDAQ:\(symbol)"
        case "Forex":
            let clean = symbol.replacingOccurrences(of: "/", with: "")
            return "FX:\(clean)"
        default:
            return symbol
        }
    }

    static func == (lhs: Asset, rhs: Asset) -> Bool { lhs.symbol == rhs.symbol }
    func hash(into hasher: inout Hasher) { hasher.combine(symbol) }
}
