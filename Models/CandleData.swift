import Foundation

struct CandleData: Identifiable {
    let id     = UUID()
    let time:   Date
    let open:   Double
    let high:   Double
    let low:    Double
    let close:  Double
    let volume: Double

    var isBullish: Bool { close >= open }
}
