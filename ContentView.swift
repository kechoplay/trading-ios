import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MarketView()
                .tabItem { Label("Markets",  systemImage: "chart.bar.fill") }
            WatchlistView()
                .tabItem { Label("Watchlist", systemImage: "star.fill") }
            SignalsView()
                .tabItem { Label("Signals", systemImage: "antenna.radiowaves.left.and.right") }
        }
        .tint(.appPrimary)
    }
}
