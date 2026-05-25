import SwiftUI

@main
struct TradeProApp: App {
    @StateObject private var marketVM    = MarketViewModel()
    @StateObject private var watchlistVM = WatchlistViewModel()
    @StateObject private var orderVM     = OrderViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(marketVM)
                .environmentObject(watchlistVM)
                .environmentObject(orderVM)
                .preferredColorScheme(.dark)
        }
    }
}
