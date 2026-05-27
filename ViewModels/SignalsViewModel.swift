import Foundation

@MainActor
class SignalsViewModel: ObservableObject {
    @Published var signals: [Signal] = []

    func add(symbol: String, setup: String, reasoning: String) {
        let direction: Signal.Direction = setup.uppercased().contains("BUY") || setup.uppercased().contains("MUA") ? .buy : .sell
        let signal = Signal(
            id:        UUID().uuidString,
            symbol:    symbol,
            direction: direction,
            setup:     setup,
            reasoning: reasoning,
            createdAt: Date()
        )
        signals.insert(signal, at: 0)
    }
}
