import SwiftUI

@main
struct TradeProApp: App {
    @StateObject private var marketVM    = MarketViewModel()
    @StateObject private var watchlistVM = WatchlistViewModel()
    @StateObject private var signalsVM   = SignalsViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(marketVM)
                .environmentObject(watchlistVM)
                .environmentObject(signalsVM)
                .preferredColorScheme(.dark)
        }
    }
}
