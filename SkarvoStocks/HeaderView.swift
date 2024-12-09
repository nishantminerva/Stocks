//
//  HeaderView.swift
//  SkarvoStocks
//
//  Created by Nishant Minerva on 12/9/24.
//

import SwiftUI

struct HeaderView: View {
    
     private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        return formatter
    }()
    
    @Binding var stocks: [String]
    
    var body: some View {
        HStack{
            VStack(alignment: .leading, spacing: -5) {
                VStack(alignment: .leading, spacing: -4) {
                    Text("Stocks")
                    Text("\(Date(), formatter: dateFormatter)")
                        .foregroundColor(Color(uiColor: .secondaryLabel))
                        .padding(.bottom)
                }
                .font(.title.weight(.heavy))
            }
            
            Spacer()
            Button {
                
            } label: {
                
            }
        }
    }
}


#Preview {
    HeaderView(stocks: .constant(["AAL", "CAA"]))
}
