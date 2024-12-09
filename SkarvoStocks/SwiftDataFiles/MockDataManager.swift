//
//  MockDataManager.swift
//  SkarvoStocks
//
//  Created by Nishant Minerva on 12/10/24.
//

import SwiftData

class MockDataManager {
    static let shared = MockDataManager()
    private var quotes: [Stock] = []
    
    init() {
        quotes = generateRandomQuotes()
    }
    
    func searchQuotes(_ query: String) -> [Stock] {
        guard !query.isEmpty else { return [] }
        return quotes.filter { $0.symbol.lowercased().contains(query.lowercased()) }
    }
    
    private func generateRandomQuotes() -> [Stock] {
        let symbols = ["AAPL", "GOOG", "MSFT", "AMZN", "META", "TSLA", "NVDA", "JPM", "BAC", "WMT"]
        var quotes: [Stock] = []
        
        for symbol in symbols {
            let basePrice = Double.random(in: 50...2000)
            let openPrice = basePrice * Double.random(in: 0.98...1.02)
            let highPrice = basePrice * Double.random(in: 1.01...1.04)
            let lowPrice = basePrice * Double.random(in: 0.96...0.99)
            let currentPrice = basePrice * Double.random(in: 0.97...1.03)
            
            let change = currentPrice - openPrice
            let changePercent = (change / openPrice) * 100
            
            let quote = Stock(
                symbol: symbol,
                open: String(format: "%.2f", openPrice),
                high: String(format: "%.2f", highPrice),
                low: String(format: "%.2f", lowPrice),
                price: String(format: "%.2f", currentPrice),
                change: String(format: "%+.2f", change),
                changePercent: String(format: "%+.2f%%", changePercent)
            )
            quotes.append(quote)
        }
        return quotes
    }
}

extension MockDataManager {
    func getAllQuotes() -> [Stock] {
        return quotes
    }
}
