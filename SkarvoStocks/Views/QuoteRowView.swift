//
//  QuoteRowView.swift
//  SkarvoStocks
//
//  Created by Nishant Minerva on 12/10/24.
//

import SwiftUI
import Charts

struct QuoteRowView: View {
    let quote: Stock
    
    // Calculate chart points using OHLC data
    var chartData: [ChartPoint] {
        [
            ChartPoint(id: 0, value: Double(quote.open) ?? 0),
            ChartPoint(id: 1, value: Double(quote.high) ?? 0),
            ChartPoint(id: 2, value: Double(quote.low) ?? 0),
            ChartPoint(id: 3, value: Double(quote.price) ?? 0)
        ]
    }
    
    var isPositive: Bool {
        Double(quote.changePercent) ?? 0 > 0.0
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(quote.symbol)
                    .font(.title2)
                    .bold()
            }
            
            Spacer()
            // Chart
            Chart(chartData) { point in
                LineMark(
                    x: .value("Time", point.id),
                    y: .value("Price", point.value)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(isPositive ? Color.green : Color.red)

                AreaMark(
                    x: .value("Time", point.id),
                    y: .value("Price", point.value)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(
                    .linearGradient(
                        colors: [isPositive ? Color.green.opacity(0.3) : Color.red.opacity(0.3), isPositive ? Color.red.opacity(0.3) : Color.red.opacity(0.1)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .foregroundStyle(isPositive ? Color.green : Color.red)
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .frame(width: 80, height: 30)
            

            
            VStack(alignment: .trailing, spacing: 2) {
                Text(quote.price)
                    .font(.title3)
                    .bold()
                
                Text("\(quote.changePercent)%")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 2)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(isPositive ? Color.green : Color.red)
                    )
            }
        }
        .padding(.vertical, 4)
    }
}
