//
//  PieChart.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-16.
//

import SwiftUI
import Charts

struct PieChartData: Identifiable {
    let id = UUID()
    let category: String
    let value: Int
}

struct PieChart: View {
    
    public let data: [String : Int]
    private let pieChartData: [PieChartData]
    private let totalValue: Int
    
    init(data: [String : Int]) {
        self.data = data
        self.totalValue = data.values.reduce(0, +)
        self.pieChartData = data.map { PieChartData(category: $0.key, value: $0.value) }
    }
    
    var body: some View {
        GroupBox {
            
            if data.isEmpty {
                Text("Can't genereate this chart because there are no sets with categorized exercises added to this routine.")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.red)
                    .padding(.all, 80)
                    .multilineTextAlignment(.center)
            } else {
                Chart(pieChartData) { element in
                    SectorMark(
                        angle: .value("Value", element.value),
                        innerRadius: .ratio(0.5),
                        angularInset: 2.0
                    )
                    .foregroundStyle(by: .value("Category", element.category))
                    .annotation(position: .overlay) {
                        Text("\(Int(Double(element.value) / Double(totalValue) * 100))%")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                }
                .chartLegend(position: .leading)
                .frame(height: 300)
            }
        }
    }
}

#Preview {
    let data = [
        "A" : 5,
        "B" : 13,
        "C" : 15
    ]
    return PieChart(data: data)
        .padding(.horizontal, 20)
}
