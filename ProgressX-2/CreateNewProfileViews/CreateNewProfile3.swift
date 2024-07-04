//
//  CreateNewProfile3.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-22.
//

import SwiftUI

struct CreateNewProfile3: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var navPath: [Int]
    
    // Fetch BodyEntries so it can be modified by the input values
    // At this state in the app there will only be one BodyEntry, the first one.
    @FetchRequest(
        entity: BodyEntry.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \BodyEntry.achievedOnDate, ascending: true)]
    ) private var bodyEntries: FetchedResults<BodyEntry>
    
    // Inputfield value states
    @State var chestCirc = ""
    @State var waistCirc = ""
    @State var thighCirc = ""
    @State var calfCirc = ""
    @State var upperArmCirc = ""
    @State var lowerArmCirc = ""
    
    // Inputfield invalid states
    @State var chestCircIsInvalid = false
    @State var waistCircIsInvalid = false
    @State var thighCircIsInvalid = false
    @State var calfCircIsInvalid = false
    @State var upperArmCircIsInvalid = false
    @State var lowerArmCircIsInvalid = false
    
    // Inputfield errormessage states
    @State var chestCircIsInvalidMsg = ""
    @State var waistCircIsInvalidMsg = ""
    @State var thighCircIsInvalidMsg = ""
    @State var calfCircIsInvalidMsg = ""
    @State var upperArmCircIsInvalidMsg = ""
    @State var lowerArmCircIsInvalidMsg = ""
    
    
    // Constants specific to elements in this view
    let inputFieldWidth = 0.2
    let minScaleFactor = 0.05
    let textWidth: Double = 200
    
    var body: some View {
        
        // Staticly fetch units
        let circumferenceUnit = PersistenceController.getLengthUnit(viewContext)!
        
        // Input form for PR's on some common exercises
        ScrollView(showsIndicators: false) {
            VStack(alignment: .center, spacing: 10) {
                
                Text("Extra information on body measurements")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(minScaleFactor);
                
                Text("Please fill in all the following fields of measurements for specific body parts, this is only your initial measurements. You can continue to add measurements when weighing-in in the future.")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .minimumScaleFactor(minScaleFactor);
                
                // Inputs for body measurements
                VStack(alignment: .center, spacing: 10) {
                    
                    Text("Circumference metrics")
                        .font(.headline)
                    
                    HStack() {
                        Text("Chest circumference")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: textWidth)
                        InputDecimalNumberField(placeHolder: circumferenceUnit, numberText: $chestCirc, markAsWrong: $chestCircIsInvalid, width: inputFieldWidth, errorMessage: $chestCircIsInvalidMsg)
                    }
                    HStack() {
                        Text("Waist circumference")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: textWidth)
                        InputDecimalNumberField(placeHolder: circumferenceUnit, numberText: $waistCirc, markAsWrong: $waistCircIsInvalid, width: inputFieldWidth, errorMessage: $waistCircIsInvalidMsg)
                    }
                    HStack() {
                        Text("Thigh circumference")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: textWidth)
                        InputDecimalNumberField(placeHolder: circumferenceUnit, numberText: $thighCirc, markAsWrong: $thighCircIsInvalid, width: inputFieldWidth, errorMessage: $thighCircIsInvalidMsg)
                    }
                    HStack() {
                        Text("Calf circumference")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: textWidth)
                        InputDecimalNumberField(placeHolder: circumferenceUnit, numberText: $calfCirc, markAsWrong: $calfCircIsInvalid, width: inputFieldWidth, errorMessage: $calfCircIsInvalidMsg)
                    }
                    HStack() {
                        Text("Lower arm circumference")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: textWidth)
                        InputDecimalNumberField(placeHolder: circumferenceUnit, numberText: $lowerArmCirc, markAsWrong: $lowerArmCircIsInvalid, width: inputFieldWidth, errorMessage: $lowerArmCircIsInvalidMsg)
                    }
                    HStack() {
                        Text("Upper arm circumference")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: textWidth)
                        InputDecimalNumberField(placeHolder: circumferenceUnit, numberText: $upperArmCirc, markAsWrong: $upperArmCircIsInvalid, width: inputFieldWidth, errorMessage: $upperArmCircIsInvalidMsg)
                    }
                    
                }
                .padding(.top, 40)
                
                Button {
                    if validateInput() {
                        addExtraInfo()
                        navPath.append(3)
                    }
                } label: {
                    Text("Continue")
                        .frame(width: 100, height: 30)
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, 40)
                
            }
        }
    }
    
    // Function for validtaing input fields, in the future, remake InputFieldvalidator to an object that has a set min/max etc and make the inputFields tagged so it can decide itself
    private func validateInput() -> Bool {
        var valid: Int = 0
        let doubleFieldValidator = DoubleFieldValidator()
        valid += doubleFieldValidator.valideField(inputVar: chestCirc, errorMessage: $chestCircIsInvalidMsg, fieldInvalid: $chestCircIsInvalid)
        valid += doubleFieldValidator.valideField(inputVar: waistCirc, errorMessage: $waistCircIsInvalidMsg, fieldInvalid: $waistCircIsInvalid)
        valid += doubleFieldValidator.valideField(inputVar: thighCirc, errorMessage: $thighCircIsInvalidMsg, fieldInvalid: $thighCircIsInvalid)
        valid += doubleFieldValidator.valideField(inputVar: calfCirc, errorMessage: $calfCircIsInvalidMsg, fieldInvalid: $calfCircIsInvalid)
        valid += doubleFieldValidator.valideField(inputVar: upperArmCirc, errorMessage: $upperArmCircIsInvalidMsg, fieldInvalid: $upperArmCircIsInvalid)
        valid += doubleFieldValidator.valideField(inputVar: lowerArmCirc, errorMessage: $lowerArmCircIsInvalidMsg, fieldInvalid: $lowerArmCircIsInvalid)
        return valid == 0
    }
    
    private func addExtraInfo() {
        let firstEntry = bodyEntries.first!
        firstEntry.chestCirc = Double(chestCirc)!
        firstEntry.waistCirc = Double(waistCirc)!
        firstEntry.thighCirc = Double(thighCirc)!
        firstEntry.calfCirc = Double(calfCirc)!
        firstEntry.uprArmCirc = Double(upperArmCirc)!
        firstEntry.lwrArmCirc = Double(lowerArmCirc)!
        PersistenceController.save(viewContext)
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    
    @State var navPath = [Int]()
    
    return CreateNewProfile3(navPath: $navPath)
       .environment(\.managedObjectContext, context)
}
