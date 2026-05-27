import SwiftUI

struct SignalsView: View {
    @EnvironmentObject var signalsVM: SignalsViewModel
    @EnvironmentObject var marketVM: MarketViewModel
    @State private var selectedSymbol: String?

    private var availableSymbols: [String] {
        marketVM.assets.map { $0.symbol }
    }

    private var filtered: [Signal] {
        guard let sym = selectedSymbol else { return signalsVM.signals }
        return signalsVM.signals.filter { $0.symbol == sym }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Symbol dropdown filter
                HStack {
                    Menu {
                        Button("Tất cả") { selectedSymbol = nil }
                        Divider()
                        ForEach(availableSymbols, id: \.self) { sym in
                            Button(sym) { selectedSymbol = sym }
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Text(selectedSymbol ?? "Tất cả symbol")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.textPrimary)
                            Image(systemName: "chevron.down")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.textSecondary)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.appSurface)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.appBorder, lineWidth: 1))
                    }

                    if selectedSymbol != nil {
                        Button {
                            selectedSymbol = nil
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.textSecondary)
                                .font(.system(size: 16))
                        }
                    }

                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.appBackground)

                Divider().background(Color.appBorder)

                if filtered.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "antenna.radiowaves.left.and.right")
                            .font(.system(size: 56))
                            .foregroundColor(.textSecondary)
                        Text("Chưa có signal")
                            .font(.system(size: 16))
                            .foregroundColor(.textSecondary)
                        Text("Mở chart và nhấn AI Analyze để tạo signal")
                            .font(.system(size: 13))
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.appBackground)
                } else {
                    List {
                        ForEach(filtered) { signal in
                            NavigationLink(value: signal) {
                                SignalRow(signal: signal)
                            }
                            .listRowBackground(Color.appSurface)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
                            .listRowSeparatorTint(.appBorder)
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(Color.appBackground)
                    .navigationDestination(for: Signal.self) { SignalDetailView(signal: $0) }
                }
            }
            .background(Color.appBackground)
            .navigationTitle("Signals")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}


// MARK: - Row

struct SignalRow: View {
    let signal: Signal

    private var isBuy: Bool  { signal.direction == .buy }
    private var color: Color { isBuy ? .gain : .loss }

    var body: some View {
        HStack(spacing: 12) {
            // Direction badge
            Text(signal.direction.rawValue)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(color)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(isBuy ? Color.gainLight : Color.lossLight)
                .cornerRadius(6)
                .frame(width: 52)

            VStack(alignment: .leading, spacing: 4) {
                Text(signal.symbol)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.textPrimary)
                Text(signal.setup)
                    .font(.system(size: 12))
                    .foregroundColor(.textSecondary)
                    .lineLimit(2)
            }

            Spacer()

            Text(Formatters.timeAgo(signal.createdAt))
                .font(.system(size: 11))
                .foregroundColor(.textSecondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

// MARK: - Detail

struct SignalDetailView: View {
    let signal: Signal

    private var isBuy: Bool  { signal.direction == .buy }
    private var color: Color { isBuy ? .gain : .loss }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack(spacing: 12) {
                    Text(signal.direction.rawValue)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(color)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(isBuy ? Color.gainLight : Color.lossLight)
                        .cornerRadius(8)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(signal.symbol)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.textPrimary)
                        Text(Formatters.timeAgo(signal.createdAt))
                            .font(.system(size: 12))
                            .foregroundColor(.textSecondary)
                    }
                }

                Divider().background(Color.appBorder)

                section(title: "Tín hiệu",          text: signal.setup)
                Divider().background(Color.appBorder)
                section(title: "Phân tích chi tiết", text: signal.reasoning)
            }
            .padding(20)
        }
        .background(Color.appBackground)
        .navigationTitle(signal.symbol)
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private func section(title: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.textSecondary)
                .textCase(.uppercase)
            Text(text)
                .font(.system(size: 15))
                .foregroundColor(.textPrimary)
                .lineSpacing(5)
        }
    }
}

extension Signal: Hashable {
    static func == (lhs: Signal, rhs: Signal) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
