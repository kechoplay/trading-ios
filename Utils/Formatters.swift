import Foundation

struct Formatters {
    private static let usd: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencySymbol = "$"
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        return f
    }()

    static func price(_ value: Double) -> String {
        if value >= 1000 {
            return usd.string(from: NSNumber(value: value)) ?? String(format: "$%.2f", value)
        }
        let decimals = value < 1 ? 6 : 2
        return String(format: "$%.\(decimals)f", value)
    }

    static func change(_ value: Double) -> String {
        let sign = value >= 0 ? "+" : ""
        return "\(sign)\(String(format: "%.2f", value))%"
    }

    static func volume(_ value: Double) -> String {
        if value >= 1_000_000_000_000 { return String(format: "%.1fT", value / 1_000_000_000_000) }
        if value >= 1_000_000_000     { return String(format: "%.1fB", value / 1_000_000_000) }
        if value >= 1_000_000         { return String(format: "%.1fM", value / 1_000_000) }
        if value >= 1_000             { return String(format: "%.1fK", value / 1_000) }
        return String(format: "%.0f", value)
    }

    static func timeAgo(_ date: Date) -> String {
        let diff = Int(Date().timeIntervalSince(date))
        if diff < 3600  { return "\(max(0, diff / 60))m ago" }
        if diff < 86400 { return "\(diff / 3600)h ago" }
        return "\(diff / 86400)d ago"
    }
}
