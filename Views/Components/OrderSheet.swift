import SwiftUI

struct OrderSheet: View {
    @EnvironmentObject var orderVM: OrderViewModel
    @Environment(\.dismiss) private var dismiss

    let asset: Asset
    let side:  OrderSide

    @State private var orderType:   OrderType = .market
    @State private var quantityStr: String    = "1"
    @State private var priceStr:    String    = ""
    @State private var submitting:  Bool      = false

    private var isBuy:     Bool  { side == .buy }
    private var sideColor: Color { isBuy ? .gain : .loss }

    private var quantity: Double { Double(quantityStr) ?? 0 }
    private var price:    Double { Double(priceStr)    ?? asset.price }
    private var total:    Double {
        quantity * (orderType == .market ? asset.price : price)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Handle bar
            Capsule()
                .fill(Color.appBorder)
                .frame(width: 36, height: 4)
                .frame(maxWidth: .infinity)
                .padding(.top, 12)
                .padding(.bottom, 8)

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Title
                    HStack {
                        Text("\(isBuy ? "Buy" : "Sell") \(asset.symbol)")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(sideColor)
                        Spacer()
                        Button { dismiss() } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.textSecondary)
                                .font(.system(size: 22))
                        }
                    }

                    Text("Market price: \(Formatters.price(asset.price))")
                        .font(.system(size: 13))
                        .foregroundColor(.textSecondary)

                    // Order type selector
                    HStack(spacing: 6) {
                        ForEach(OrderType.allCases) { t in
                            Button {
                                orderType = t
                            } label: {
                                Text(t.displayName)
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(orderType == t ? .appPrimary : .textSecondary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                                    .background(
                                        orderType == t
                                            ? Color.appPrimary.opacity(0.15)
                                            : Color.appSurfaceVariant
                                    )
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(orderType == t ? Color.appPrimary : Color.appBorder, lineWidth: 1)
                                    )
                            }
                        }
                    }

                    // Quantity field
                    InputField(label: "Quantity", text: $quantityStr, prefix: nil)

                    // Price field (limit / stop-loss only)
                    if orderType != .market {
                        InputField(
                            label: orderType == .limit ? "Limit Price" : "Stop Price",
                            text:  $priceStr,
                            prefix: "$"
                        )
                    }

                    // Estimated total
                    HStack {
                        Text("Estimated Total")
                            .font(.system(size: 14))
                            .foregroundColor(.textSecondary)
                        Spacer()
                        Text(Formatters.price(total))
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.textPrimary)
                    }
                    .padding(12)
                    .background(Color.appSurfaceVariant)
                    .cornerRadius(8)

                    // Submit button
                    Button {
                        Task { await submit() }
                    } label: {
                        if submitting {
                            ProgressView()
                                .tint(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                        } else {
                            Text("\(isBuy ? "Place Buy" : "Place Sell") Order")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                        }
                    }
                    .background(submitting ? sideColor.opacity(0.5) : sideColor)
                    .cornerRadius(12)
                    .disabled(submitting || quantity <= 0)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
        }
        .background(Color.appSurface)
        .onAppear { priceStr = String(format: "%.2f", asset.price) }
    }

    private func submit() async {
        guard quantity > 0 else { return }
        submitting = true
        try? await Task.sleep(nanoseconds: 600_000_000)
        orderVM.placeOrder(
            symbol:   asset.symbol,
            side:     side,
            type:     orderType,
            quantity: quantity,
            price:    orderType == .market ? asset.price : price
        )
        submitting = false
        dismiss()
    }
}

// MARK: - InputField

private struct InputField: View {
    let label:  String
    @Binding var text: String
    let prefix: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.textSecondary)
            HStack {
                if let prefix {
                    Text(prefix).foregroundColor(.textSecondary)
                }
                TextField("", text: $text)
                    .keyboardType(.decimalPad)
                    .foregroundColor(.textPrimary)
                    .font(.system(size: 15, weight: .semibold))
            }
            .padding(12)
            .background(Color.appSurfaceVariant)
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.appBorder, lineWidth: 1))
        }
    }
}
