//
//  StockDataPoint.swift
//  SkarvoStocks
//
//  Created by Nishant Minerva on 12/10/24.
//

import Foundation

struct StockDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let price: Double
    let volume: Int
}
