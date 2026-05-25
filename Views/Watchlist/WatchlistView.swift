import SwiftUI

struct WatchlistView: View {
    @EnvironmentObject var marketVM:    MarketViewModel
    @EnvironmentObject var watchlistVM: WatchlistViewModel

    private var watchedAssets: [Asset] {
        watchlistVM.symbols.compactMap { marketVM.find(symbol: $0) }
    }

    var body: some View {
        NavigationStack {
            Group {
                if watchedAssets.isEmpty {
                    emptyState
                } else {
                    assetList
                }
            }
            .background(Color.appBackground)
            .navigationTitle("Watchlist")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "star")
                .font(.system(size: 64))
                .foregroundColor(.textSecondary)
            Text("No assets in watchlist")
                .font(.system(size: 16))
                .foregroundColor(.textSecondary)
            Text("Tap the star on any asset to add it")
                .font(.system(size: 13))
                .foregroundColor(.textSecondary)
            Button("Browse Markets") { }
                .buttonStyle(.borderedProminent)
                .tint(.appPrimary)
        }
    }

    private var assetList: some View {
        List {
            ForEach(watchedAssets) { asset in
                NavigationLink(value: asset) { AssetRow(asset: asset) }
                    .listRowBackground(Color.appSurface)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
                    .listRowSeparatorTint(.appBorder)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            watchlistVM.remove(asset.symbol)
                        } label: {
                            Label("Remove", systemImage: "trash")
                        }
                    }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color.appBackground)
        .navigationDestination(for: Asset.self) { ChartView(asset: $0) }
    }
}
