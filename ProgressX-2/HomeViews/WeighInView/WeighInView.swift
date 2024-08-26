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
                    .padding(.horizontal, 20)
                
                LightSubHeadline(text: "Here you can weigh in with your current weight and optionally your current body measurements")
                    .padding(.bottom, 10)
                    .padding(.horizontal, 20)
                
                BoldSubHeadline(text: "Bodyweight")
                
                DecimalTextField(
                    placeHolder: "Bodyweight (\(viewModel.weightUnit(viewContext)))",
                    numberText: $viewModel.bodyWeight,
                    markAsWrong: $viewModel.bodyWeightIsInvalid,
                    errorMessage: $viewModel.bodyWeightIsInvalidMsg
                )
                .padding(.horizontal, 60)
                .padding(.bottom, 10)
                
                BoldSubHeadline(text: "Body measurements")
                
                LightSubHeadline(text: "These values or optional and doesn't need too be filled in")
                    .padding(.horizontal, 20)
                
                DecimalTextField(
                    placeHolder: "Chest circumference (\(viewModel.lengthUnit(viewContext)))",
                    numberText: $viewModel.chestCirc,
                    markAsWrong: $viewModel.chestCircIsInvalid,
                    errorMessage: $viewModel.chestCircIsInvalidMsg
                )
                .padding(.horizontal, 60)
                .padding(.bottom, 10)
                
                DecimalTextField(
                    placeHolder: "Upper arm circumference (\(viewModel.lengthUnit(viewContext)))",
                    numberText: $viewModel.upperArmCirc,
                    markAsWrong: $viewModel.upperArmCircIsInvalid,
                    errorMessage: $viewModel.upperArmCircIsInvalidMsg
                )
                .padding(.horizontal, 60)
                .padding(.bottom, 10)
                
                DecimalTextField(
                    placeHolder: "Lower arm circumference (\(viewModel.lengthUnit(viewContext)))",
                    numberText: $viewModel.lowerArmCirc,
                    markAsWrong: $viewModel.lowerArmIsInvalid,
                    errorMessage: $viewModel.lowerArmIsInvalidMsg
                )
                .padding(.horizontal, 60)
                .padding(.bottom, 10)
                
                DecimalTextField(
                    placeHolder: "Waist circumference (\(viewModel.lengthUnit(viewContext)))",
                    numberText: $viewModel.waistCirc,
                    markAsWrong: $viewModel.waistCircIsInvalid,
                    errorMessage: $viewModel.waistCircIsInvalidMsg
                )
                .padding(.horizontal, 60)
                .padding(.bottom, 10)
                
                DecimalTextField(
                    placeHolder: "Thigh circumference (\(viewModel.lengthUnit(viewContext)))",
                    numberText: $viewModel.thighCirc,
                    markAsWrong: $viewModel.thighCircIsInvalid,
                    errorMessage: $viewModel.thighCircIsInvalidMsg
                )
                .padding(.horizontal, 60)
                .padding(.bottom, 10)
                
                DecimalTextField(
                    placeHolder: "Calf circumference (\(viewModel.lengthUnit(viewContext)))",
                    numberText: $viewModel.calfCirc,
                    markAsWrong: $viewModel.calfCircIsInvalid,
                    errorMessage: $viewModel.calfCircIsInvalidMsg
                )
                .padding(.horizontal, 60)
                
                Button {
                    if validateInput() {
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
    
    let context = PersistenceController.previewViewContext
    @State var navPath: [Int] = [Int]()
    
    return WeighInView(
        navPath: $navPath
    )
    .environment(\.managedObjectContext, context)
}
