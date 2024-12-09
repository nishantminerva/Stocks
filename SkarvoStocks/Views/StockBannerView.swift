//
//  StockBannerView.swift
//  SkarvoStocks
//
//  Created by Nishant Minerva on 12/10/24.
//

import SwiftUI

struct StockBannerView: View {
    @State private var offset: CGFloat = 0
    let quotes: [Stock]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(quotes + quotes) { quote in // Doubled for continuous scrolling effect
                    VStack(alignment: .leading, spacing: 4) {
                        Text(quote.symbol)
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        MiniChartView() // Small line chart
                            .frame(width: 50, height: 20)
                        
                        HStack {
                            Text(quote.price)
                            Text(quote.changePercent)
                        }
                        .font(.subheadline)
                        .foregroundColor(quote.change.hasPrefix("-") ? .red : .green)
                    }
                    .frame(width: 100)
                }
            }
            .offset(x: offset)
            .onAppear {
                withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                    offset = -CGFloat(quotes.count) * 120 // Adjust based on item width + spacing
                }
            }
        }
        .frame(height: 80)
        .background(Color.black)
    }
}
