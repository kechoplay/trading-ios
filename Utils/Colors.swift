import SwiftUI

extension Color {
    static let appPrimary        = Color(hex: "00C896")
    static let appBackground     = Color(hex: "0D1117")
    static let appSurface        = Color(hex: "161B22")
    static let appSurfaceVariant = Color(hex: "21262D")
    static let textPrimary       = Color(hex: "E6EDF3")
    static let textSecondary     = Color(hex: "8B949E")
    static let gain              = Color(hex: "00C896")
    static let loss              = Color(hex: "FF4B4B")
    static let gainLight         = Color(hex: "00C896").opacity(0.125)
    static let lossLight         = Color(hex: "FF4B4B").opacity(0.125)
    static let appBorder         = Color(hex: "30363D")
    static let accent            = Color(hex: "58A6FF")

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:  (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:  (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:  (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB,
                  red:     Double(r) / 255,
                  green:   Double(g) / 255,
                  blue:    Double(b) / 255,
                  opacity: Double(a) / 255)
    }
}
