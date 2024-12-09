//
//  ImageOnCircle.swift
//  SkarvoStocks
//
//  Created by Nishant Minerva on 12/10/24.
//

import SwiftUI

struct ImageOnCircle: View {
    
    let icon: String
    let radius: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .fill(.ultraThinMaterial)
                .frame(width: radius * 2, height: radius * 2)
            Image(systemName: icon)
                .bold()
                .foregroundColor(.cyan)
        }
    }
}
