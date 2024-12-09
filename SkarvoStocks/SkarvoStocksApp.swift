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
            container = try ModelContainer(for: Quote.self)
        } catch {
            fatalError("Failed to create ModelContainer for Quote: \(error)")
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
