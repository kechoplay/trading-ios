import SwiftUI
import Charts

// MARK: - Entry Point

struct PriceChartView: View {
    let candles:     [CandleData]
    let showCandles: Bool
    let asset:       Asset

    var body: some View {
        if candles.isEmpty {
            ProgressView().tint(.appPrimary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if showCandles {
            CandleChartView(candles: Array(candles.suffix(30)))
        } else {
            LineChartView(candles: candles, asset: asset)
        }
    }
}

// MARK: - Line Chart (Swift Charts, iOS 16+)

private struct LineChartView: View {
    let candles: [CandleData]
    let asset:   Asset

    private var minClose: Double { candles.map(\.close).min() ?? 0 }

    var body: some View {
        Chart {
            ForEach(Array(candles.enumerated()), id: \.offset) { i, c in
                LineMark(x: .value("i", i), y: .value("Price", c.close))
                    .foregroundStyle(asset.isGain ? Color.gain : Color.loss)
                    .interpolationMethod(.catmullRom)
                AreaMark(
                    x: .value("i", i),
                    yStart: .value("min", minClose),
                    yEnd:   .value("Price", c.close)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            (asset.isGain ? Color.gain : Color.loss).opacity(0.3),
                            (asset.isGain ? Color.gain : Color.loss).opacity(0.0),
                        ],
                        startPoint: .top, endPoint: .bottom
                    )
                )
                .interpolationMethod(.catmullRom)
            }
        }
        .chartXAxis(.hidden)
        .chartYAxis {
            AxisMarks(position: .trailing) { value in
                AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                    .foregroundStyle(Color.appBorder)
                AxisValueLabel {
                    if let v = value.as(Double.self) {
                        Text(Formatters.price(v))
                            .font(.system(size: 10))
                            .foregroundColor(.textSecondary)
                    }
                }
            }
        }
        .background(Color.appBackground)
    }
}

// MARK: - Candle Chart (Canvas)

private struct CandleChartView: View {
    let candles: [CandleData]

    private var minPrice: Double { candles.flatMap { [$0.high, $0.low] }.min() ?? 0 }
    private var maxPrice: Double { candles.flatMap { [$0.high, $0.low] }.max() ?? 1 }
    private var priceRange: Double { max(maxPrice - minPrice, 0.0001) }

    private func toY(_ price: Double, height: CGFloat) -> CGFloat {
        let padding = height * 0.05
        return height - padding - CGFloat((price - minPrice) / priceRange) * (height - padding * 2)
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topTrailing) {
                Canvas { ctx, size in
                    let candleW = size.width / CGFloat(candles.count)
                    let bodyW   = candleW * 0.6

                    // Grid lines
                    for i in 0...4 {
                        let price = minPrice + priceRange * Double(i) / 4
                        let y     = toY(price, height: size.height)
                        var grid  = Path()
                        grid.move(to:    CGPoint(x: 0,              y: y))
                        grid.addLine(to: CGPoint(x: size.width - 56, y: y))
                        ctx.stroke(grid, with: .color(Color.appBorder), lineWidth: 0.5)
                    }

                    // Candles
                    for (i, c) in candles.enumerated() {
                        let x     = CGFloat(i) * candleW + candleW / 2
                        let color: Color = c.isBullish ? .gain : .loss

                        var wick = Path()
                        wick.move(to:    CGPoint(x: x, y: toY(c.high, height: size.height)))
                        wick.addLine(to: CGPoint(x: x, y: toY(c.low,  height: size.height)))
                        ctx.stroke(wick, with: .color(color), lineWidth: 1)

                        let top    = toY(c.isBullish ? c.close : c.open,  height: size.height)
                        let bottom = toY(c.isBullish ? c.open  : c.close, height: size.height)
                        let bH     = max(1, abs(bottom - top))
                        let rect   = CGRect(x: x - bodyW / 2, y: top, width: bodyW, height: bH)
                        ctx.fill(Path(roundedRect: rect, cornerRadius: 1), with: .color(color))
                    }
                }

                // Price axis labels overlay
                VStack(alignment: .trailing) {
                    ForEach(Array((0...4).reversed()), id: \.self) { i in
                        let price = minPrice + priceRange * Double(i) / 4
                        let label = price < 10
                            ? String(format: "$%.4f", price)
                            : String(format: "$%.0f", price)
                        Spacer(minLength: 0)
                        Text(label)
                            .font(.system(size: 9))
                            .foregroundColor(.textSecondary)
                    }
                    Spacer(minLength: 0)
                }
                .frame(width: 54)
                .frame(maxHeight: geo.size.height)
                .padding(.trailing, 2)
            }
        }
        .background(Color.appBackground)
    }
}
