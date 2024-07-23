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
            VStack {
                
                BoldTitle(text: "Weigh in")
                
                LightSubHeadline(text: "Here you can weigh in with your current weight and optionally your current body measurements")
                    .padding(.bottom, 10)
                    .padding(.horizontal, 20)
                
                BoldSubHeadline(text: "Bodyweight")
                
                let weightUnit = PersistenceController.getWeightUnit(viewContext)!
                
                let lengthUnit = PersistenceController.getLengthUnit(viewContext)!
                
                InputDecimalNumberField(
                    placeHolder: "Bodyweight (\(weightUnit))",
                    allowNegatives: false,
                    numberText: $viewModel.bodyWeight,
                    markAsWrong: $viewModel.bodyWeightIsInvalid,
                    width: 0.6,
                    errorMessage: $viewModel.bodyWeightIsInvalidMsg
                )
                .padding(.bottom, 10)
                
                BoldSubHeadline(text: "Body measurements")
                
                LightSubHeadline(text: "These values or optional and doesn't need too be filled in")
                    .padding(.horizontal, 20)
                
                InputDecimalNumberField(
                    placeHolder: "Chest circumference (\(lengthUnit))",
                    allowNegatives: false,
                    numberText: $viewModel.chestCirc,
                    markAsWrong: $viewModel.chestCircIsInvalid,
                    width: 0.6,
                    errorMessage: $viewModel.chestCircIsInvalidMsg
                )
                .padding(.bottom, 10)
                
                InputDecimalNumberField(
                    placeHolder: "Upper arm circumference (\(lengthUnit))",
                    allowNegatives: false,
                    numberText: $viewModel.upperArmCirc,
                    markAsWrong: $viewModel.upperArmCircIsInvalid,
                    width: 0.6,
                    errorMessage: $viewModel.upperArmCircIsInvalidMsg
                )
                .padding(.bottom, 10)
                
                InputDecimalNumberField(
                    placeHolder: "Lower arm circumference (\(lengthUnit))",
                    allowNegatives: false,
                    numberText: $viewModel.lowerArmCirc,
                    markAsWrong: $viewModel.lowerArmIsInvalid,
                    width: 0.6,
                    errorMessage: $viewModel.lowerArmIsInvalidMsg
                )
                .padding(.bottom, 10)
                
                InputDecimalNumberField(
                    placeHolder: "Waist circumference (\(lengthUnit))",
                    allowNegatives: false,
                    numberText: $viewModel.waistCirc,
                    markAsWrong: $viewModel.waistCircIsInvalid,
                    width: 0.6,
                    errorMessage: $viewModel.waistCircIsInvalidMsg
                )
                .padding(.bottom, 10)
                
                InputDecimalNumberField(
                    placeHolder: "Thigh circumference (\(lengthUnit))",
                    allowNegatives: false,
                    numberText: $viewModel.thighCirc,
                    markAsWrong: $viewModel.thighCircIsInvalid,
                    width: 0.6,
                    errorMessage: $viewModel.thighCircIsInvalidMsg
                )
                .padding(.bottom, 10)
                
                InputDecimalNumberField(
                    placeHolder: "Calf circumference (\(lengthUnit))",
                    allowNegatives: false,
                    numberText: $viewModel.calfCirc,
                    markAsWrong: $viewModel.calfCircIsInvalid,
                    width: 0.6,
                    errorMessage: $viewModel.calfCircIsInvalidMsg
                )
                .padding(.bottom, 20)
                
                Button {
                    if validateInput() {
                        viewModel.saveNewWeighIn(viewContext: viewContext)
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
                .padding(.bottom, 10)
                
            }
        }
    }
    
    private func validateInput() -> Bool {
        var valid: Int = 0
        let bodyWeightValidator = DoubleFieldValidator(maxInputNumber: 1000)
        let bodyMeasurementValidator = DoubleFieldValidator(emptyAllowed: true, maxInputNumber: 1000)
        
        valid += bodyWeightValidator.valideField(
            inputVar: viewModel.bodyWeight,
            errorMessage: $viewModel.bodyWeightIsInvalidMsg,
            fieldInvalid: $viewModel.bodyWeightIsInvalid
        )
        
        valid += bodyMeasurementValidator.valideField(
            inputVar: viewModel.chestCirc,
            errorMessage: $viewModel.chestCircIsInvalidMsg,
            fieldInvalid: $viewModel.chestCircIsInvalid
        )
        
        valid += bodyMeasurementValidator.valideField(
            inputVar: viewModel.upperArmCirc,
            errorMessage: $viewModel.upperArmCircIsInvalidMsg,
            fieldInvalid: $viewModel.upperArmCircIsInvalid
        )
        
        valid += bodyMeasurementValidator.valideField(
            inputVar: viewModel.lowerArmCirc,
            errorMessage: $viewModel.lowerArmIsInvalidMsg,
            fieldInvalid: $viewModel.lowerArmIsInvalid
        )
        
        valid += bodyMeasurementValidator.valideField(
            inputVar: viewModel.waistCirc,
            errorMessage: $viewModel.waistCircIsInvalidMsg,
            fieldInvalid: $viewModel.waistCircIsInvalid
        )
        
        valid += bodyMeasurementValidator.valideField(
            inputVar: viewModel.thighCirc,
            errorMessage: $viewModel.thighCircIsInvalidMsg,
            fieldInvalid: $viewModel.thighCircIsInvalid
        )
        
        valid += bodyMeasurementValidator.valideField(
            inputVar: viewModel.calfCirc,
            errorMessage: $viewModel.calfCircIsInvalidMsg,
            fieldInvalid: $viewModel.calfCircIsInvalid
        )
        
        return valid == 0
        
    }
    
}

#Preview {
    
    let context = PersistenceController.preview.container.viewContext
    @State var navPath: [Int] = [Int]()
    
    return WeighInView(
        navPath: $navPath
    )
    .environment(\.managedObjectContext, context)
}
