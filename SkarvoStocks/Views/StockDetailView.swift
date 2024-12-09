//
//  StockDetailView.swift
//  SkarvoStocks
//
//  Created by Nishant Minerva on 12/10/24.
//

import SwiftUI
import Charts

struct StockDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let quote: Stock
    @State private var selectedTimeRange: TimeRange = .day
    @State private var chartData: [StockDataPoint] = []
    @State private var selectedDataPoint: StockDataPoint?

    enum TimeRange: String, CaseIterable {
        case day = "1D"
        case week = "1W"
        case month = "1M"
        case threeMonths = "3M"
        case year = "1Y"
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Header
                    headerView
                    
                    // Price Chart
                    priceChartSection
                    
                    // Time Range Selector
                    timeRangeSelector
                    
                    // Stats Grid
                    statsGridView
                    
                    // Volume Chart
                    volumeChartSection
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { /* Add more actions */ }) {
                    Image(systemName: "ellipsis.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .onAppear {
            generateRandomData()
        }
    }

    private var headerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(quote.symbol)
                .font(.largeTitle)
                .bold()

            HStack {
                Text(quote.price)
                    .font(.title)
                Text(quote.changePercent)
                    .foregroundColor(quote.change.hasPrefix("-") ? .red : .green)
            }
        }
    }

    private var priceChartSection: some View {
        VStack(alignment: .leading) {
            Text("Price")
                .font(.headline)

            Chart {
                ForEach(chartData) { point in
                    LineMark(
                        x: .value("Time", point.date),
                        y: .value("Price", point.price)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(Color.blue.opacity(0.8))

                    AreaMark(
                        x: .value("Time", point.date),
                        y: .value("Price", point.price)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(
                        .linearGradient(
                            colors: [.blue.opacity(0.3), .blue.opacity(0.1)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }

                if let selected = selectedDataPoint {
                    RuleMark(x: .value("Time", selected.date))
                        .foregroundStyle(.gray.opacity(0.3))
                }
            }
            .frame(height: 200)
            .chartXAxis {
                AxisMarks(position: .bottom)
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .chartOverlay { proxy in
                GeometryReader { geometry in
                    Rectangle()
                        .fill(.clear)
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let x = value.location.x - geometry[proxy.plotAreaFrame].origin.x
                                    guard let date = proxy.value(atX: x, as: Date.self) else { return }

                                    selectedDataPoint = chartData.min(by: {
                                        abs($0.date.timeIntervalSince(date)) < abs($1.date.timeIntervalSince(date))
                                    })
                                }
                                .onEnded { _ in
                                    selectedDataPoint = nil
                                }
                        )
                }
            }
        }
    }

    private var timeRangeSelector: some View {
        HStack {
            ForEach(TimeRange.allCases, id: \.self) { range in
                Button(action: {
                    selectedTimeRange = range
                    generateRandomData()
                }) {
                    Text(range.rawValue)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(selectedTimeRange == range ? .blue : .clear)
                        .foregroundColor(selectedTimeRange == range ? .white : .blue)
                        .cornerRadius(8)
                }
            }
        }
    }

    private var statsGridView: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            StatView(title: "Open", value: quote.open)
            StatView(title: "High", value: quote.high)
            StatView(title: "Low", value: quote.low)
            StatView(title: "Volume", value: "\(Int.random(in: 1000000...10000000))")
            StatView(title: "52W High", value: String(format: "%.2f", Double(quote.high)! * 1.2))
            StatView(title: "52W Low", value: String(format: "%.2f", Double(quote.low)! * 0.8))
        }
    }

    private var volumeChartSection: some View {
        VStack(alignment: .leading) {
            Text("Volume")
                .font(.headline)

            Chart {
                ForEach(chartData) { point in
                    BarMark(
                        x: .value("Time", point.date),
                        y: .value("Volume", point.volume)
                    )
                    .foregroundStyle(Color.blue.opacity(0.3))
                }
            }
            .frame(height: 100)
            .chartXAxis {
                AxisMarks(position: .bottom)
            }
        }
    }

    private func generateRandomData() {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let now = Date()

        let numberOfPoints: Int
        let interval: TimeInterval

        switch selectedTimeRange {
        case .day:
            numberOfPoints = 390  // Trading minutes in a day
            interval = 60  // 1 minute
        case .week:
            numberOfPoints = 7 * 24
            interval = 3600  // 1 hour
        case .month:
            numberOfPoints = 30
            interval = 86400  // 1 day
        case .threeMonths:
            numberOfPoints = 90
            interval = 86400  // 1 day
        case .year:
            numberOfPoints = 252  // Trading days in a year
            interval = 86400  // 1 day
        }

        let basePrice = Double(quote.price)!
        chartData = (0..<numberOfPoints).map { i in
            let date = calendar.date(byAdding: .second, value: -Int(interval * Double(numberOfPoints - i - 1)), to: now)!
            let randomFactor = Double.random(in: 0.98...1.02)
            let price = basePrice * randomFactor
            let volume = Int.random(in: 100000...1000000)
            return StockDataPoint(date: date, price: price, volume: volume)
        }
    }
}
