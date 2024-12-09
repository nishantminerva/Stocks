//
//  HomeView.swift
//  SkarvoStocks
//
//  Created by Nishant Minerva on 12/9/24.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var savedQuotes: [Stock]
    @State private var searchText = ""
    @State private var searchResults: [Stock] = []
    @State private var selectedQuote: Stock?
    @State private var selectedDetent: PresentationDetent = .height(100)
    @State private var selectedColor: Color = Color.accentColor
    @State private var isSearchActive = false
    @FocusState private var isSearchFocused: Bool
    
    @State private var selection = "Red"
      let colors = ["Red", "Green", "Blue", "Black", "Tartan"]
    
    var displayedQuotes: [Stock] {
        if searchText.isEmpty {
            return Array(savedQuotes)
        } else {
            return searchResults
        }
    }
    
    private let subtitleDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "d MMMM"
        return df
    }()
    
    var body: some View {
            VStack(spacing: 0) {
                // Banner Section
                if selectedQuote != nil {
                    StockBannerView(quotes: MockDataManager.shared.getAllQuotes())
                }
                if !isSearchFocused {
                    HStack(alignment: .center){
                        VStack(alignment: .leading, spacing: -10) {
                            Text("Stocks")
                            Text(subtitleDateFormatter.string(from: Date()))
                                .foregroundColor(Color(uiColor: .secondaryLabel))
                        }
                        .font(.title.weight(.heavy))
                        Spacer()
                        Menu {
                            Button {
                                dummyAction()
                            } label: {
                                Label("Edit Watchlist", systemImage: "pencil")
                            }
                            Button {
                                dummyAction()
                            } label: {
                                Label("Show Currency", systemImage: "indianrupeesign")
                            }
                            Button {
                                dummyAction()
                            } label: {
                                Label("Options", systemImage: "paperplane")
                            }
                            
                            Picker("Sort Watchlist By", selection: $selection) {
                                ForEach(colors, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(.menu)
                            
                        } label: {
                            ImageOnCircle(icon: "ellipsis", radius: 15)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Custom Search Field
                HStack {
                    HStack(spacing: 2) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search", text: $searchText)
                            .focused($isSearchFocused)
                            .autocorrectionDisabled()
                    }
                    .padding(5)
                    .background(RoundedRectangle(cornerRadius: 8).fill(.gray.opacity(0.2)))
                    if isSearchFocused {
                        Button("Done") {
                            isSearchFocused = false
                            searchText = ""
                            searchResults.removeAll()
                        }
                        .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal)
                
                // Search and List Section
                List {
                    ForEach(displayedQuotes) { quote in
                        HStack {
                            if isSearchFocused {
                                Button(action: {
                                    if isQuoteSaved(quote) {
                                        if let savedQuote = findSavedQuote(quote) {
                                            modelContext.delete(savedQuote)
                                        }
                                    } else {
                                        modelContext.insert(quote)
                                    }
                                }) {
                                    Image(systemName: isQuoteSaved(quote) ? "checkmark.circle.fill" : "plus.circle")
                                        .foregroundColor(.cyan)
                                        .font(.title2)
                                }
                            }
                            Spacer()
                            QuoteRowView(quote: quote)
                                .onTapGesture {
                                    selectedQuote = quote
                                }
                        }
                    }
                    .onDelete(perform: deleteQuotes)
                }
                .onChange(of: searchText) { _, newValue in
                    searchResults = MockDataManager.shared.searchQuotes(newValue)
                }
            }
            .frame(alignment: .top)
            .navigationBarHidden(true)
            
            // Detail Sheet
            .sheet(item: $selectedQuote) { quote in
                StockDetailView(quote: quote)
                    .presentationDetents([.height(UIScreen.main.bounds.height * 0.8)])
                    .presentationDragIndicator(.visible)
            }
            
            // Swift Logo Sheet
            .sheet(isPresented: .constant(true)) {
                VStack {
                    Image(systemName: "swift")
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .foregroundStyle(selectedColor)
                    if selectedDetent != .height(100) {
                        Text("New will Appear here!")
                    }
                }
                .presentationDetents([.height(100), .medium, .large], selection: $selectedDetent)
                .interactiveDismissDisabled(true)
                .presentationBackgroundInteraction(.enabled(upThrough: .height(100)))
            }
    }
    
    // Helper Functions
    private func isQuoteSaved(_ quote: Stock) -> Bool {
        savedQuotes.contains { $0.symbol == quote.symbol }
    }
    
    private func findSavedQuote(_ quote: Stock) -> Stock? {
        savedQuotes.first { $0.symbol == quote.symbol }
    }
    
    private func deleteQuotes(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(savedQuotes[index])
        }
    }
    
    func dummyAction() { }

}

#Preview {
    NavigationStack {
        HomeView()
    }
    .preferredColorScheme(.dark)
}
