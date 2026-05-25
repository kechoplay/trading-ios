# TradePro — Swift/SwiftUI

Bản chuyển đổi từ Flutter sang Swift/SwiftUI thuần native iOS.

## Yêu cầu

- Xcode 14+
- iOS 16+ (dùng Swift Charts + NavigationStack + presentationDetents)

## Cách tạo project trong Xcode

1. Mở Xcode → **File > New > Project**
2. Chọn **iOS > App**, đặt tên `TradePro`
3. Interface: **SwiftUI**, Language: **Swift**
4. Lưu project vào thư mục bất kỳ
5. Xoá các file mặc định: `ContentView.swift`, `TradePro_AppApp.swift` (hoặc tên app)
6. Kéo **toàn bộ folder** `Models/`, `ViewModels/`, `Views/`, `Utils/` và 2 file gốc vào Xcode
7. Đảm bảo **"Copy items if needed"** được chọn
8. Build & Run trên Simulator iOS 16+

## Cấu trúc file

```
TradePro/
├── TradeProApp.swift           # Entry point (@main)
├── ContentView.swift           # TabView 3 tab
├── Models/
│   ├── Asset.swift             # Struct tài sản
│   ├── CandleData.swift        # OHLCV cho chart
│   └── Order.swift             # Lệnh + enums
├── ViewModels/
│   ├── MarketViewModel.swift   # Live price feed (Timer 3s)
│   ├── WatchlistViewModel.swift# UserDefaults persistence
│   └── OrderViewModel.swift    # Quản lý lệnh + số dư
├── Views/
│   ├── Market/
│   │   ├── MarketView.swift    # Tab Markets + search
│   │   └── MarketSummaryCard.swift
│   ├── Watchlist/
│   │   └── WatchlistView.swift # Swipe-to-delete
│   ├── Orders/
│   │   └── OrdersView.swift    # Open / History tab
│   ├── Chart/
│   │   └── ChartView.swift     # Candle + Line chart, Buy/Sell
│   └── Components/
│       ├── AssetRow.swift      # Row tài sản + sparkline
│       ├── PriceChartView.swift# Swift Charts (line) + Canvas (candle)
│       └── OrderSheet.swift    # Bottom sheet đặt lệnh
└── Utils/
    ├── Colors.swift            # Color extensions (dark theme)
    ├── Formatters.swift        # Định dạng giá, %, volume
    └── MockData.swift          # 16 assets, candle generator
```

## So sánh Flutter → SwiftUI

| Flutter               | SwiftUI                     |
|-----------------------|-----------------------------|
| `ChangeNotifier`      | `ObservableObject`          |
| `Provider`            | `@EnvironmentObject`        |
| `StatefulWidget`      | `@State` / `@StateObject`   |
| `Navigator.push`      | `NavigationStack` + `NavigationLink(value:)` |
| `showModalBottomSheet`| `.sheet` + `.presentationDetents` |
| `CustomPainter`       | `Canvas`                    |
| `fl_chart`            | `Swift Charts` (iOS 16+)    |
| `SharedPreferences`   | `UserDefaults`              |
| `Timer.periodic`      | `Timer.scheduledTimer`      |
