import Foundation

class WatchlistViewModel: ObservableObject {
    @Published var symbols: Set<String> = []

    init() {
        if let saved = UserDefaults.standard.stringArray(forKey: "watchlist") {
            symbols = Set(saved)
        } else {
            symbols = ["BTC", "ETH", "AAPL"]
        }
    }

    func isWatching(_ symbol: String) -> Bool { symbols.contains(symbol) }

    func toggle(_ symbol: String) {
        if symbols.contains(symbol) { symbols.remove(symbol) } else { symbols.insert(symbol) }
        save()
    }

    func remove(_ symbol: String) {
        symbols.remove(symbol)
        save()
    }

    private func save() {
        UserDefaults.standard.set(Array(symbols), forKey: "watchlist")
    }
}
