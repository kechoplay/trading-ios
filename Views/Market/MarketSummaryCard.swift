import SwiftUI

struct MarketSummaryCard: View {
    let market: String
    let assets: [Asset]

    private var gainers:     Int    { assets.filter(\.isGain).count }
    private var losers:      Int    { assets.count - gainers }
    private var avgChange:   Double {
        guard !assets.isEmpty else { return 0 }
        return assets.map(\.change).reduce(0, +) / Double(assets.count)
    }
    private var totalVolume: Double { assets.map(\.volume).reduce(0, +) }

    var body: some View {
        if !assets.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(market)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.textPrimary)
                    Spacer()
                    Text("Avg \(Formatters.change(avgChange))")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(avgChange >= 0 ? .gain : .loss)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(avgChange >= 0 ? Color.gainLight : Color.lossLight)
                        .cornerRadius(8)
                }
                HStack(spacing: 24) {
                    SummaryMetric(label: "Gainers",    value: "\(gainers)",                       color: .gain)
                    SummaryMetric(label: "Losers",     value: "\(losers)",                        color: .loss)
                    SummaryMetric(label: "Volume 24H", value: Formatters.volume(totalVolume),     color: .accent)
                }
            }
            .padding(16)
            .background(
                LinearGradient(
                    colors: avgChange >= 0
                        ? [Color.gainLight, Color.appSurface]
                        : [Color.lossLight, Color.appSurface],
                    startPoint: .topLeading,
                    endPoint:   .bottomTrailing
                )
            )
            .cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.appBorder, lineWidth: 0.5))
        }
    }
}

private struct SummaryMetric: View {
    let label: String
    let value: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(.textSecondary)
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(color)
        }
    }
}
