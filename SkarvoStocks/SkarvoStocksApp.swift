//
//  SkarvoStocksApp.swift
//  SkarvoStocks
//
//  Created by Nishant Minerva on 12/9/24.
//

/*
 
 iOS Coding Assignment
 
 Build an iOS app that looks like Stocks iOS app (something as shown in this video https://www.youtube.com/watch?v=qk53Soq46wI)
 This app should be written in SwiftUI
 Just like this app it will have main scroll view that shows the stocks symbols and it will have a tray sheet
 The tray sheet can be minimum state, middle state or large size (which is about 90% of device height)
 When app launches first time the stocks list will be empty
 Use the mock data model to define the data for each row of main scroll view list (just in memory array)
 There will be a plus button on main navigation bar and user can click on that to create new row and add in the model and show in list
 User can delete the symbols by swiping left
 App should support dynamic font size
 App should work as expected in Dark and Light mode
 BONUS: If tray sheet is in middle and if user scrolls the main scrolls view up then tray sheet moves to bottom
 BONUS: Instead of hardcoding the mock data in array, can you store using SwiftData?
 Send the github repository link after completing the application
 
 */
                                                 
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
