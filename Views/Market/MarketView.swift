import SwiftUI

struct MarketView: View {
    @EnvironmentObject var marketVM: MarketViewModel
    @State private var selectedMarket  = "Forex"
    @State private var searchText      = ""
    @State private var showSettings    = false

    private let markets = ["Forex", "Crypto"]

    private var searchResults: [Asset] {
        guard !searchText.isEmpty else { return [] }
        let q = searchText.lowercased()
        return marketVM.assets.filter {
            $0.symbol.lowercased().contains(q) || $0.name.lowercased().contains(q)
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if marketVM.isLoading {
                    ProgressView()
                        .tint(.appPrimary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.appBackground)
                } else if !searchText.isEmpty {
                    assetList(searchResults)
                } else {
                    VStack(spacing: 0) {
                        Picker("Market", selection: $selectedMarket) {
                            ForEach(markets, id: \.self) { Text($0) }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)
                        .padding(.top, 8)
                        MarketListView(market: selectedMarket)
                    }
                }
            }
            .background(Color.appBackground)
            .navigationTitle("TradePro")
            .searchable(text: $searchText, prompt: "Search assets")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showSettings = true } label: { Image(systemName: "gearshape") }
                        .foregroundColor(.textPrimary)
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
        }
    }

    @ViewBuilder
    private func assetList(_ assets: [Asset]) -> some View {
        List(assets) { asset in
            NavigationLink(value: asset) { AssetRow(asset: asset) }
                .listRowBackground(Color.appSurface)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
                .listRowSeparatorTint(.appBorder)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color.appBackground)
        .navigationDestination(for: Asset.self) { ChartView(asset: $0) }
    }
}

// MARK: - Per-market list

struct MarketListView: View {
    @EnvironmentObject var marketVM: MarketViewModel
    let market: String

    private var assets: [Asset] { marketVM.assets(for: market) }

    var body: some View {
        List {
            Section {
                MarketSummaryCard(market: market, assets: assets)
                    .listRowBackground(Color.appBackground)
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .listRowSeparator(.hidden)
            }
            ForEach(assets) { asset in
                NavigationLink(value: asset) { AssetRow(asset: asset) }
                    .listRowBackground(Color.appSurface)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
                    .listRowSeparatorTint(.appBorder)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color.appBackground)
        .refreshable { try? await Task.sleep(nanoseconds: 1_000_000_000) }
        .navigationDestination(for: Asset.self) { ChartView(asset: $0) }
    }
}
