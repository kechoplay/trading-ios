import SwiftUI

struct AIAnalysisSheet: View {
    let asset: Asset
    @Environment(\.dismiss) private var dismiss

    @State private var result: AIAnalysisResult? = nil
    @State private var isLoading = true
    @State private var errorMessage: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Handle bar
            Capsule()
                .fill(Color.appBorder)
                .frame(width: 36, height: 4)
                .frame(maxWidth: .infinity)
                .padding(.top, 12)
                .padding(.bottom, 16)

            // Header
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "sparkles")
                        .foregroundColor(.appPrimary)
                        .font(.system(size: 18, weight: .semibold))
                    Text("AI Analysis")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.textPrimary)
                }
                Spacer()
                Button { dismiss() } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.textSecondary)
                        .font(.system(size: 22))
                }
            }
            .padding(.horizontal, 20)

            Text("\(asset.symbol) · \(asset.name)")
                .font(.system(size: 13))
                .foregroundColor(.textSecondary)
                .padding(.horizontal, 20)
                .padding(.top, 4)

            Divider()
                .background(Color.appBorder)
                .padding(.vertical, 16)

            // Content
            ScrollView {
                Group {
                    if isLoading {
                        VStack(spacing: 16) {
                            ProgressView()
                                .tint(.appPrimary)
                                .scaleEffect(1.2)
                            Text("Đang phân tích...")
                                .font(.system(size: 14))
                                .foregroundColor(.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 40)
                    } else if let err = errorMessage {
                        VStack(spacing: 12) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 32))
                                .foregroundColor(.loss)
                            Text(err)
                                .font(.system(size: 14))
                                .foregroundColor(.textSecondary)
                                .multilineTextAlignment(.center)
                            Button("Thử lại") { Task { await load() } }
                                .foregroundColor(.appPrimary)
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 40)
                    } else if let r = result {
                        VStack(alignment: .leading, spacing: 20) {
                            analysisSection(title: "Tín hiệu", content: r.setup)
                            Divider().background(Color.appBorder)
                            analysisSection(title: "Phân tích chi tiết", content: r.reasoning)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
        .background(Color.appSurface)
        .task { await load() }
    }

    @ViewBuilder
    private func analysisSection(title: String, content: AttributedString) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.textSecondary)
                .textCase(.uppercase)
            Text(content)
                .font(.system(size: 15))
                .lineSpacing(5)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private func load() async {
        isLoading = true
        errorMessage = nil
        do {
            result = try await AIAnalysisService.analyze(asset: asset)
        } catch {
            errorMessage = "Không thể kết nối AI. Vui lòng kiểm tra API key."
        }
        isLoading = false
    }
}
