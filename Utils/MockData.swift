import Foundation

struct MockData {
    static let assets: [Asset] = [
        // Crypto
        Asset(symbol: "BTC",     name: "Bitcoin",               price: 67432.50, change:  2.34, volume: 28_500_000_000, marketCap: 1_320_000_000_000, market: "Crypto", iconHex: "F7931A"),
        Asset(symbol: "ETH",     name: "Ethereum",              price:  3512.80, change: -1.12, volume: 14_200_000_000, marketCap:   421_000_000_000, market: "Crypto", iconHex: "627EEA"),
        Asset(symbol: "SOL",     name: "Solana",                price:   178.40, change:  5.67, volume:  4_800_000_000, marketCap:    78_000_000_000, market: "Crypto", iconHex: "9945FF"),
        Asset(symbol: "BNB",     name: "BNB",                   price:   598.20, change:  0.89, volume:  2_100_000_000, marketCap:    87_000_000_000, market: "Crypto", iconHex: "F3BA2F"),
        Asset(symbol: "ADA",     name: "Cardano",               price:    0.5842,change: -2.45, volume:    890_000_000, marketCap:    20_500_000_000, market: "Crypto", iconHex: "0033AD"),
        Asset(symbol: "DOGE",    name: "Dogecoin",              price:    0.1732,change:  3.21, volume:  1_200_000_000, marketCap:    24_800_000_000, market: "Crypto", iconHex: "C2A633"),
        // Stocks
        Asset(symbol: "AAPL",    name: "Apple Inc.",            price:   189.30, change:  0.45, volume:     58_000_000, marketCap: 2_950_000_000_000, market: "Stocks", iconHex: "999999"),
        Asset(symbol: "MSFT",    name: "Microsoft",             price:   420.55, change:  1.23, volume:     22_000_000, marketCap: 3_120_000_000_000, market: "Stocks", iconHex: "00A4EF"),
        Asset(symbol: "NVDA",    name: "NVIDIA",                price:   875.40, change:  4.12, volume:     41_000_000, marketCap: 2_150_000_000_000, market: "Stocks", iconHex: "76B900"),
        Asset(symbol: "TSLA",    name: "Tesla",                 price:   175.20, change: -2.87, volume:     95_000_000, marketCap:   558_000_000_000, market: "Stocks", iconHex: "CC0000"),
        Asset(symbol: "META",    name: "Meta",                  price:   512.80, change:  1.56, volume:     18_000_000, marketCap: 1_308_000_000_000, market: "Stocks", iconHex: "0080FB"),
        Asset(symbol: "AMZN",    name: "Amazon",                price:   187.40, change:  0.78, volume:     32_000_000, marketCap: 1_960_000_000_000, market: "Stocks", iconHex: "FF9900"),
        // Forex
        Asset(symbol: "XAU/USD", name: "Gold / US Dollar",   price: 2340.50, change:  0.62, volume: 150_000_000, marketCap: 0, market: "Forex", iconHex: "FFD700"),
        Asset(symbol: "XAG/USD", name: "Silver / US Dollar", price:   30.45, change: -0.38, volume:  80_000_000, marketCap: 0, market: "Forex", iconHex: "C0C0C0"),
    ]

    static func generateCandles(basePrice: Double, count: Int) -> [CandleData] {
        var candles: [CandleData] = []
        var price = basePrice
        let now = Date()
        let volatility = basePrice * 0.02

        for i in stride(from: count, through: 0, by: -1) {
            let open   = price
            let change = Double.random(in: -0.48...0.52) * volatility
            let close  = open + change
            let high   = max(open, close) + Double.random(in: 0...(volatility * 0.5))
            let low    = min(open, close) - Double.random(in: 0...(volatility * 0.5))
            let vol    = basePrice * 100 * Double.random(in: 0.5...2.5)
            candles.append(CandleData(
                time: now.addingTimeInterval(Double(-i) * 4 * 3600),
                open: open, high: high, low: low, close: close, volume: vol
            ))
            price = close
        }
        return candles
    }

    static let sampleOrders: [Order] = [
        Order(id: "1", symbol: "BTC",  side: .buy,  type: .market, quantity: 0.05, price: 67000, status: .filled, createdAt: Date().addingTimeInterval(-7_200)),
        Order(id: "2", symbol: "ETH",  side: .sell, type: .limit,  quantity: 1.5,  price: 3600,  status: .open,   createdAt: Date().addingTimeInterval(-18_000)),
        Order(id: "3", symbol: "AAPL", side: .buy,  type: .market, quantity: 10,   price: 189,   status: .filled, createdAt: Date().addingTimeInterval(-86_400)),
    ]
}
