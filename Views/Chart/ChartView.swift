import SwiftUI

struct ChartView: View {
    let asset: Asset

    @EnvironmentObject var marketVM:    MarketViewModel
    @EnvironmentObject var watchlistVM: WatchlistViewModel
    @EnvironmentObject var signalsVM:   SignalsViewModel

    @State private var interval      = "4H"
    @State private var orderSide: OrderSide? = nil
    @State private var showAIAnalysis = false

    private let intervals     = ["1H", "4H", "1D", "1W", "1M"]
    private let tvIntervalMap = ["1H": "60", "4H": "240", "1D": "D", "1W": "W", "1M": "M"]

    private var live: Asset       { marketVM.find(symbol: asset.symbol) ?? asset }
    private var isWatching: Bool  { watchlistVM.isWatching(live.symbol) }
    private var tvInterval: String { tvIntervalMap[interval] ?? "240" }

    var body: some View {
        VStack(spacing: 0) {
            priceHeader
            intervalRow
            TradingViewWebView(symbol: live.tradingViewSymbol, interval: tvInterval)
            analyzeBar
        }
        .background(Color.appBackground)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { toolbarContent }
        .sheet(isPresented: $showAIAnalysis) {
            AIAnalysisSheet(asset: live, onSave: { setup, reasoning in
                signalsVM.add(symbol: live.symbol, setup: setup, reasoning: reasoning)
            })
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
    }

    // MARK: Sub-views

    private var priceHeader: some View {
        HStack(alignment: .bottom, spacing: 12) {
            Text(Formatters.price(live.price))
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(live.isGain ? .gain : .loss)
            Text(Formatters.change(live.change))
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(live.isGain ? .gain : .loss)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(live.isGain ? Color.gainLight : Color.lossLight)
                .cornerRadius(6)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }

    private var intervalRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                ForEach(intervals, id: \.self) { iv in
                    ChipButton(label: iv, selected: interval == iv) { interval = iv }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }

    private var analyzeBar: some View {
        Button { showAIAnalysis = true } label: {
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .font(.system(size: 15, weight: .semibold))
                Text("AI Analyze")
                    .font(.system(size: 15, weight: .bold))
            }
            .foregroundColor(.appBackground)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.appPrimary)
            .cornerRadius(12)
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 20)
    }

    private var tradeButtons: some View {
        HStack(spacing: 12) {
            Button("Buy")  { orderSide = .buy }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.gain)
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .bold))
                .cornerRadius(12)
            Button("Sell") { orderSide = .sell }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.loss)
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .bold))
                .cornerRadius(12)
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 20)
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            VStack(spacing: 1) {
                Text(live.symbol)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.textPrimary)
                Text(live.name)
                    .font(.system(size: 11))
                    .foregroundColor(.textSecondary)
            }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button { watchlistVM.toggle(live.symbol) } label: {
                Image(systemName: isWatching ? "star.fill" : "star")
                    .foregroundColor(isWatching ? .yellow : .textSecondary)
            }
        }
    }
}

// MARK: - ChipButton

struct ChipButton: View {
    let label:    String
    let selected: Bool
    let action:   () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(selected ? Color.appBackground : Color.textSecondary)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(selected ? Color.appPrimary : Color.appSurfaceVariant)
                .cornerRadius(8)
        }
    }
}

// MARK: - StatItem

private struct StatItem: View {
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 2) {
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(.textSecondary)
            Text(value)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.textPrimary)
        }
    }
}

// MARK: - OrderSide: Identifiable (for .sheet(item:))

extension OrderSide: Identifiable {
    public var id: String { rawValue }
}
