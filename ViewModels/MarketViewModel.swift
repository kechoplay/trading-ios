import SwiftUI

class MarketViewModel: ObservableObject {
    @Published var assets:    [Asset] = []
    @Published var isLoading: Bool    = true

    private var timer: Timer?

    init() {
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 500_000_000)
            self.assets    = MockData.assets
            self.isLoading = false
            self.startPriceFeed()
        }
    }

    func assets(for market: String) -> [Asset] {
        assets.filter { $0.market == market }
    }

    func find(symbol: String) -> Asset? {
        assets.first { $0.symbol == symbol }
    }

    func candles(for symbol: String) -> [CandleData] {
        guard let asset = find(symbol: symbol) else { return [] }
        return MockData.generateCandles(basePrice: asset.price, count: 90)
    }

    private func startPriceFeed() {
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.assets = self.assets.map { asset in
                    var a = asset
                    let delta = Double.random(in: -0.49..<0.51) * asset.price * 0.003
                    a.price  = max(0.0001, asset.price + delta)
                    a.change = min(30, max(-30, asset.change + Double.random(in: -0.5...0.5) * 0.1))
                    return a
                }
            }
        }
    }

    deinit { timer?.invalidate() }
}
