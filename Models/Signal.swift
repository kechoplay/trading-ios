import Foundation

struct Signal: Identifiable {
    let id:        String
    let symbol:    String
    let direction: Direction
    let setup:     String
    let reasoning: String
    let createdAt: Date

    enum Direction: String {
        case buy  = "BUY"
        case sell = "SELL"
    }

}
