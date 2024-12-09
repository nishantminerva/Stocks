//
//  SkarvoStocksApp.swift
//  SkarvoStocks
//
//  Created by Nishant Minerva on 12/9/24.
//

import SwiftUI
import SwiftData

@main
struct SkarvoStocksApp: App {
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: Stock.self)
        } catch {
            fatalError("Failed to create ModelContainer for Stock: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
            }
        }
        .modelContainer(container)
    }
}
