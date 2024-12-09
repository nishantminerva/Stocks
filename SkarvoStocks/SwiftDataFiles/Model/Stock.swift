//
//  Stock.swift
//  SkarvoStocks
//
//  Created by Nishant Minerva on 12/10/24.
//

import SwiftData

@Model
class Stock {
    var symbol: String
    var open: String
    var high: String
    var low: String
    var price: String
    var change: String
    var changePercent: String
    
    init(symbol: String, open: String, high: String, low: String, price: String, change: String, changePercent: String) {
        self.symbol = symbol
        self.open = open
        self.high = high
        self.low = low
        self.price = price
        self.change = change
        self.changePercent = changePercent
    }
}
