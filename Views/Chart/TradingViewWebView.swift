import SwiftUI
import WebKit

struct TradingViewWebView: UIViewRepresentable {
    let symbol:   String  // TradingView format, e.g. "BINANCE:BTCUSDT"
    let interval: String  // "60", "240", "D", "W", "M"

    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> WKWebView {
        let cfg = WKWebViewConfiguration()
        cfg.allowsInlineMediaPlayback = true
        let wv = WKWebView(frame: .zero, configuration: cfg)
        wv.scrollView.isScrollEnabled = false
        wv.isOpaque = false
        wv.backgroundColor = .clear
        return wv
    }

    func updateUIView(_ wv: WKWebView, context: Context) {
        let key = "\(symbol)|\(interval)"
        guard context.coordinator.lastKey != key else { return }
        context.coordinator.lastKey = key
        wv.loadHTMLString(html, baseURL: URL(string: "https://s3.tradingview.com"))
    }

    class Coordinator {
        var lastKey: String = ""
    }

    private var html: String {
        """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1">
            <style>
                *{margin:0;padding:0;box-sizing:border-box}
                html,body{width:100%;height:100%;background:#0D0D0D}
            </style>
        </head>
        <body>
            <div id="tv" style="width:100%;height:100vh"></div>
            <script src="https://s3.tradingview.com/tv.js"></script>
            <script>
            new TradingView.widget({
                container_id:       "tv",
                width:              "100%",
                height:             "100%",
                symbol:             "\(symbol)",
                interval:           "\(interval)",
                timezone:           "exchange",
                theme:              "dark",
                style:              "1",
                locale:             "en",
                toolbar_bg:         "#0D0D0D",
                enable_publishing:  false,
                allow_symbol_change: false,
                hide_top_toolbar:   false,
                save_image:         false
            });
            </script>
        </body>
        </html>
        """
    }
}
