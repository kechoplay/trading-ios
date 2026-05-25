import SwiftUI

struct OrdersView: View {
    @EnvironmentObject var orderVM: OrderViewModel
    @State private var selectedTab = 0

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("", selection: $selectedTab) {
                    Text("Open").tag(0)
                    Text("History").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.vertical, 8)

                if selectedTab == 0 {
                    OrderList(orders: orderVM.openOrders, showCancel: true)
                } else {
                    OrderList(orders: orderVM.filledOrders, showCancel: false)
                }
            }
            .background(Color.appBackground)
            .navigationTitle("Orders")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    VStack(alignment: .trailing, spacing: 0) {
                        Text("Balance")
                            .font(.system(size: 11))
                            .foregroundColor(.textSecondary)
                        Text(Formatters.price(orderVM.balance))
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.appPrimary)
                    }
                }
            }
        }
    }
}

// MARK: - Order List

private struct OrderList: View {
    let orders:     [Order]
    let showCancel: Bool

    var body: some View {
        if orders.isEmpty {
            VStack(spacing: 16) {
                Image(systemName: "doc.text")
                    .font(.system(size: 64))
                    .foregroundColor(.textSecondary)
                Text("No orders yet")
                    .font(.system(size: 16))
                    .foregroundColor(.textSecondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(orders) { order in
                        OrderCard(order: order, showCancel: showCancel)
                    }
                }
                .padding(12)
            }
        }
    }
}

// MARK: - Order Card

private struct OrderCard: View {
    @EnvironmentObject var orderVM: OrderViewModel
    let order:      Order
    let showCancel: Bool

    private var isBuy:     Bool  { order.side == .buy }
    private var sideColor: Color { isBuy ? .gain : .loss }

    var body: some View {
        VStack(spacing: 10) {
            // Header row
            HStack {
                Text(isBuy ? "BUY" : "SELL")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(sideColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(isBuy ? Color.gainLight : Color.lossLight)
                    .cornerRadius(6)

                Text(order.symbol)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.textPrimary)

                Text(order.type.displayName.uppercased())
                    .font(.system(size: 10))
                    .foregroundColor(.textSecondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.appSurfaceVariant)
                    .cornerRadius(4)

                Spacer()

                if showCancel && order.status == .open {
                    Button("Cancel") { orderVM.cancelOrder(id: order.id) }
                        .font(.system(size: 13))
                        .foregroundColor(.loss)
                }
            }

            // Info row
            HStack {
                OrderInfoItem(label: "Qty",   value: "\(order.quantity)")
                Spacer()
                OrderInfoItem(label: "Price", value: Formatters.price(order.price))
                Spacer()
                OrderInfoItem(label: "Total", value: Formatters.price(order.total))
                Spacer()
                OrderInfoItem(label: "Time",  value: Formatters.timeAgo(order.createdAt))
            }
        }
        .padding(14)
        .background(Color.appSurface)
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.appBorder, lineWidth: 0.5))
    }
}

private struct OrderInfoItem: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(.textSecondary)
            Text(value)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.textPrimary)
        }
    }
}
