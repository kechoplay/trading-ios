# TradePro — Flutter iOS Trading App

Ứng dụng trading đa thị trường cho iOS: Crypto, Stocks, Forex.

## Tính năng

- **Markets**: Danh sách tài sản theo thời gian thực (mô phỏng), lọc theo Crypto / Stocks / Forex
- **Biểu đồ**: Candlestick chart và Line chart với nhiều khung thời gian
- **Watchlist**: Theo dõi tài sản yêu thích, kéo để xóa
- **Đặt lệnh**: Market, Limit, Stop-Loss orders với xác nhận
- **Lịch sử lệnh**: Open orders và filled orders

## Cài đặt

```bash
flutter pub get
cd ios && pod install
flutter run
```

## Yêu cầu

- Flutter SDK >= 3.0.0
- Xcode >= 14 (để build iOS)
- iOS Simulator hoặc thiết bị thật

## Cấu trúc

```
lib/
├── main.dart           # Entry point
├── app.dart            # MaterialApp + theme
├── models/             # Asset, CandleData, Order
├── providers/          # State management (Provider)
├── screens/            # Màn hình chính
│   ├── home_screen.dart       # Bottom nav
│   ├── market_screen.dart     # Danh sách thị trường
│   ├── chart_screen.dart      # Biểu đồ chi tiết
│   ├── watchlist_screen.dart  # Watchlist
│   ├── orders_screen.dart     # Lịch sử lệnh
│   └── order_sheet.dart       # Form đặt lệnh
├── widgets/
│   ├── asset_tile.dart        # Row tài sản với sparkline
│   ├── price_chart.dart       # Candlestick + Line chart
│   └── market_summary_card.dart
└── utils/
    ├── constants.dart   # Colors, styles
    ├── formatters.dart  # Định dạng giá, số
    └── mock_data.dart   # Dữ liệu mô phỏng
```
