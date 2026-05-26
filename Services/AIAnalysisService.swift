import Foundation

struct AIAnalysisResult {
    let setup:     AttributedString
    let reasoning: AttributedString
}

struct AIAnalysisService {
    private static let apiURL = "http://localhost:3000/api/analyze"

    static var apiKey: String {
        get { UserDefaults.standard.string(forKey: "ai_api_key") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "ai_api_key") }
    }

    static func analyze(asset: Asset) async throws -> AIAnalysisResult {
        let body: [String: Any] = ["symbol": asset.symbol, "force": true]

        var request = URLRequest(url: URL(string: apiURL)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey,             forHTTPHeaderField: "X-API-Key")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        let setup     = json?["setup"]     as? String ?? ""
        let reasoning = json?["reasoning"] as? String ?? ""

        return AIAnalysisResult(
            setup:     parseHTML(setup),
            reasoning: parseHTML(reasoning)
        )
    }

    private static func parseHTML(_ html: String) -> AttributedString {
        let wrapped = "<span style=\"font-family: -apple-system; font-size: 15px; color: #E6EDF3;\">\(html)</span>"
        guard
            let data = wrapped.data(using: .utf8),
            let ns = try? NSAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html,
                          .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil
            ),
            let attr = try? AttributedString(ns, including: \.uiKit)
        else {
            return AttributedString(html.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression))
        }
        return attr
    }
}
