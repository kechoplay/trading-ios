import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MarketView()
                .tabItem { Label("Markets",  systemImage: "chart.bar.fill") }
            WatchlistView()
                .tabItem { Label("Watchlist", systemImage: "star.fill") }
            OrdersView()
                .tabItem { Label("Orders",   systemImage: "doc.text.fill") }
        }
        .tint(.appPrimary)
    }
}
