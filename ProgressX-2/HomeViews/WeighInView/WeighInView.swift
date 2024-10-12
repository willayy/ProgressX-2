//
//  WeighInView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-17.
//

import SwiftUI

struct WeighInView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = WeighInViewModel()
    @Binding var navPath: [Int]
    
    var body: some View {
        
        ScrollView {
            
            // MARK: Body weight
            BoldTitle(text: "Weigh in")
                .padding(.horizontal, 20)
            
            let weightUnit = viewModel.weightUnit(viewContext)
            
            LightSubHeadline(text: "Here you can weigh in with your current weight and optionally your current body measurements")
                .padding(.bottom, 10)
                .padding(.horizontal, 20)
            
            BoldSubHeadline(text: "Bodyweight")
            
            InputField(
                placeHolder: "Bodyweight (\(weightUnit))",
                text: $viewModel.bodyWeight,
                variant: DecimalIF(
                    min: 0,
                    max: 1000
                )
            )
            .padding(.horizontal, 60)
            .padding(.bottom, 10)
            
            // MARK: Body measurements
            BoldSubHeadline(text: "Body measurements")
            
            let lenghtUnit = viewModel.lengthUnit(viewContext)
            
            LightSubHeadline(text: "These values or optional and doesn't need too be filled in")
                .padding(.horizontal, 20)
            
            InputField(
                placeHolder: "Chest circumference (\(lenghtUnit))",
                text: $viewModel.chestCirc,
                variant: DecimalIF(
                    min: 0,
                    max: 1000
                )
            )
            .padding(.horizontal, 60)
            .padding(.bottom, 10)
            
            InputField(
                placeHolder: "Upper arm circumference (\(lenghtUnit))",
                text: $viewModel.upperArmCirc,
                variant: DecimalIF(
                    min: 0,
                    max: 1000
                )
            )
            .padding(.horizontal, 60)
            .padding(.bottom, 10)
            
            InputField(
                placeHolder: "Lower arm circumference (\(lenghtUnit))",
                text: $viewModel.lowerArmCirc,
                variant: DecimalIF(
                    min: 0,
                    max: 1000
                )
            )
            .padding(.horizontal, 60)
            .padding(.bottom, 10)
            
            InputField(
                placeHolder: "Waist circumference (\(lenghtUnit))",
                text: $viewModel.waistCirc,
                variant: DecimalIF(
                    min: 0,
                    max: 1000
                )
            )
            .padding(.horizontal, 60)
            .padding(.bottom, 10)
            
            InputField(
                placeHolder: "Thigh circumference (\(lenghtUnit))",
                text: $viewModel.thighCirc,
                variant: DecimalIF(
                    min: 0,
                    max: 1000
                )
            )
            .padding(.horizontal, 60)
            .padding(.bottom, 10)
            
            InputField(
                placeHolder: "Calf circumference (\(lenghtUnit))",
                text: $viewModel.calfCirc,
                variant: DecimalIF(
                    min: 0,
                    max: 1000
                )
            )
            .padding(.horizontal, 60)
            
        }
        
        // MARK: Add Weigh-in button
        Button {
            
            if GlobalInputFieldValidator.allFieldsValid() {
                
                viewModel.saveEntry(viewContext: viewContext)
                
                navPath.removeLast()
                
            }
            
        } label: {
            
            Text("Add weigh-in")
                .frame(height: 40)
                .foregroundColor(Color("buttonTextColor"))
            
            Image(systemName: "plus")
                .foregroundColor(Color("buttonTextColor"))
            
        }
        .buttonStyle(BorderedProminentButtonStyle())
        .padding(.top, 20)
        .padding(.bottom, 10)

    }
    
}

#Preview {
    
    let context = PersistenceController.previewViewContext
    @State var navPath: [Int] = [Int]()
    
    return WeighInView(
        navPath: $navPath
    )
    .environment(\.managedObjectContext, context)
}
