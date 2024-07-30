//
//  BodyEntryChart.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-17.
//

import SwiftUI
import Charts
import CoreData

private struct BodyEntryData: Identifiable {
    var id = UUID()
    var date: Date
    var bodyWeight: Double
    var chestCirc: Double?
    var waistCirc: Double?
    var upperArmCirc: Double?
    var lowerArmCirc: Double?
    var thighCirc: Double?
    var calfCirc: Double?
}


struct BodyEntryChart: View {
    
    private let selections: [String] = [
        "Bodyweight",
        "Chest circumference",
        "Waist circumference",
        "Upper arm circumference",
        "Lower arm circumference",
        "Thigh circumference",
        "Calf circumference"
    ]
    
    private let bodyEntryData: [BodyEntryData]
    @State private var measurementSelection: String = "Bodyweight"
    
    init(bodyEntryData: [BodyEntry]) {
        self.bodyEntryData = bodyEntryData.map({
            BodyEntryData(
                date: $0.achievedOnDate!,
                bodyWeight: $0.bodyWeight,
                chestCirc: $0.chestCirc?.doubleValue,
                waistCirc: $0.waistCirc?.doubleValue,
                upperArmCirc: $0.uprArmCirc?.doubleValue,
                lowerArmCirc: $0.lwrArmCirc?.doubleValue,
                thighCirc: $0.thighCirc?.doubleValue,
                calfCirc: $0.calfCirc?.doubleValue
            )
        })
    }
    
    var body: some View {
        GroupBox {
            Chart {
                ForEach(bodyEntryData) { data in
                    switch measurementSelection {
                    case "Bodyweight":
                        chartElement(x: data.date, y: data.bodyWeight, color: .yellow)
                    case "Chest circumference":
                        if data.chestCirc != nil {
                            chartElement(x: data.date, y: data.chestCirc!, color: .blue)
                        }
                    case "Waist circumference":
                        if data.waistCirc != nil {
                            chartElement(x: data.date, y: data.waistCirc!, color: .green)
                        }
                    case "Upper arm circumference":
                        if data.upperArmCirc != nil {
                            chartElement(x: data.date, y: data.upperArmCirc!, color: .red)
                        }
                    case "Lower arm circumference":
                        if data.lowerArmCirc != nil {
                            chartElement(x: data.date, y: data.lowerArmCirc!, color: .orange)
                        }
                    case "Thigh circumference":
                        if data.thighCirc != nil {
                            chartElement(x: data.date, y: data.thighCirc!, color: .cyan)
                        }
                    case "Calf circumference":
                        if data.calfCirc != nil {
                            chartElement(x: data.date, y: data.calfCirc!, color: .brown)
                        }
                    default:
                        /* If some undefined behaviour appears 
                        with the measurementSelection default to
                        bodyweight */
                        chartElement(x: data.date, y: data.bodyWeight, color: .yellow)
                    }
                    
                }
            }
            
            Picker("Select a metric", selection: $measurementSelection) {
                ForEach(selections, id: \.self) { item in
                    Text(item)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
    }
    
    @ChartContentBuilder
    func chartElement(x: Date, y: Double, color: Color) -> some ChartContent {
        LineMark(
            x: .value("Date", x),
            y: .value("Value", y)
        )
        .foregroundStyle(color)

        PointMark(
            x: .value("Date", x),
            y: .value("Value", y)
        )
        .foregroundStyle(color)
    }
    
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let fetchRequest: NSFetchRequest<BodyEntry> = BodyEntry.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \BodyEntry.achievedOnDate, ascending: true)]
    let results = PersistenceController.fetch(context, fetchRequest: fetchRequest)

    return BodyEntryChart(bodyEntryData: results)
    
}
