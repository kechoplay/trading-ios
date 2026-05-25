import SwiftUI

struct AssetRow: View {
    let asset: Asset

    private var iconLabel: String {
        let s = asset.symbol
        let clean = s.replacingOccurrences(of: "/", with: "")
        return String(clean.prefix(2))
    }

    var body: some View {
        HStack(spacing: 12) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(asset.iconColor.opacity(0.15))
                    .frame(width: 44, height: 44)
                Text(iconLabel)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(asset.iconColor)
            }

            // Name & Symbol
            VStack(alignment: .leading, spacing: 2) {
                Text(asset.symbol)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.textPrimary)
                Text(asset.name)
                    .font(.system(size: 12))
                    .foregroundColor(.textSecondary)
                    .lineLimit(1)
            }

            Spacer()

            SparklineView(isGain: asset.isGain)
                .frame(width: 60, height: 32)

            // Price & Change
            VStack(alignment: .trailing, spacing: 2) {
                Text(Formatters.price(asset.price))
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.textPrimary)
                Text(Formatters.change(asset.change))
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(asset.isGain ? .gain : .loss)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 2)
                    .background(asset.isGain ? Color.gainLight : Color.lossLight)
                    .cornerRadius(4)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
    }
}

// MARK: - Sparkline

struct SparklineView: View {
    let isGain: Bool

    private let gainPts: [CGFloat] = [0.5, 0.4, 0.6, 0.45, 0.55, 0.4, 0.3, 0.35, 0.2, 0.15]
    private let lossPts: [CGFloat] = [0.3, 0.35, 0.25, 0.45, 0.4, 0.55, 0.6, 0.5, 0.65, 0.75]

    var body: some View {
        Canvas { ctx, size in
            let pts   = isGain ? gainPts : lossPts
            let color = isGain ? Color.gain : Color.loss
            var path  = Path()
            for (i, y) in pts.enumerated() {
                let x = CGFloat(i) / CGFloat(pts.count - 1) * size.width
                if i == 0 { path.move(to:    CGPoint(x: x, y: y * size.height)) }
                else       { path.addLine(to: CGPoint(x: x, y: y * size.height)) }
            }
            ctx.stroke(path, with: .color(color), style: StrokeStyle(lineWidth: 1.5, lineJoin: .round))
        }
    }
}
