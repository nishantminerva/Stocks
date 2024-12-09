//
//  MiniChartView.swift
//  SkarvoStocks
//
//  Created by Nishant Minerva on 11/10/24.
//

import SwiftUI

struct MiniChartView: View {
    var body: some View {
        Path { path in
            let points = (0...20).map { CGPoint(x: Double($0) * 2.5, y: Double.random(in: 0...20)) }
            
            path.move(to: points[0])
            for point in points.dropFirst() {
                path.addLine(to: point)
            }
        }
        .stroke(Color.green, style: StrokeStyle(lineWidth: 1, lineCap: .round))
    }
}

