import Foundation

class OrderViewModel: ObservableObject {
    @Published var orders:  [Order] = MockData.sampleOrders
    @Published var balance: Double  = 50_000.0

    var openOrders:   [Order] { orders.filter { $0.status == .open } }
    var filledOrders: [Order] { orders.filter { $0.status == .filled } }

    func placeOrder(symbol: String, side: OrderSide, type: OrderType, quantity: Double, price: Double) {
        let order = Order(
            id:        String(Int(Date().timeIntervalSince1970 * 1000)),
            symbol:    symbol,
            side:      side,
            type:      type,
            quantity:  quantity,
            price:     price,
            status:    type == .market ? .filled : .open,
            createdAt: Date()
        )
        if side == .buy && type == .market { balance -= order.total }
        orders.insert(order, at: 0)
    }

    func cancelOrder(id: String) {
        guard let i = orders.firstIndex(where: { $0.id == id }) else { return }
        orders[i].status = .cancelled
    }
}
