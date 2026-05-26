import SwiftUI

struct SettingsView: View {
    @AppStorage("ai_api_key") private var apiKey = ""
    @Environment(\.dismiss) private var dismiss
    @State private var keyInput = ""
    @State private var saved    = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    SecureField("Nhập API Key", text: $keyInput)
                        .foregroundColor(.textPrimary)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                } header: {
                    Text("AI Analyze API Key")
                } footer: {
                    Text("Key được lưu trên thiết bị và dùng cho tất cả lần gọi AI Analyze.")
                }

                if !apiKey.isEmpty {
                    Section {
                        HStack {
                            Text("Key hiện tại")
                                .foregroundColor(.textSecondary)
                            Spacer()
                            Text(maskedKey)
                                .foregroundColor(.textSecondary)
                                .font(.system(size: 13, design: .monospaced))
                        }
                        Button("Xoá key", role: .destructive) {
                            apiKey   = ""
                            keyInput = ""
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.appBackground)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Huỷ") { dismiss() }
                        .foregroundColor(.textSecondary)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Lưu") { save() }
                        .foregroundColor(.appPrimary)
                        .fontWeight(.semibold)
                        .disabled(keyInput.isEmpty)
                }
            }
            .overlay {
                if saved {
                    savedToast
                }
            }
        }
        .onAppear { keyInput = "" }
    }

    private var maskedKey: String {
        guard apiKey.count > 6 else { return String(repeating: "•", count: apiKey.count) }
        return String(apiKey.prefix(4)) + "••••" + String(apiKey.suffix(4))
    }

    private var savedToast: some View {
        VStack {
            Spacer()
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.appPrimary)
                Text("Đã lưu API Key")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.textPrimary)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Color.appSurface)
            .cornerRadius(24)
            .shadow(color: .black.opacity(0.3), radius: 8)
            .padding(.bottom, 40)
        }
    }

    private func save() {
        apiKey = keyInput
        AIAnalysisService.apiKey = keyInput
        keyInput = ""
        saved = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { saved = false }
    }
}
