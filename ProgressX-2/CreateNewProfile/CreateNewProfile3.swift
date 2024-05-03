//
//  CreateNewProfile3.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-22.
//

import SwiftUI

struct CreateNewProfile3: View {
    
    @State var chestCirc = ""
    @State var waistCirc = ""
    @State var thighCirc = ""
    @State var calfCirc = ""
    @State var upperArmCirc = ""
    @State var lowerArmCirc = ""
    
    @State var benchPress1RM = ""
    @State var squat1RM = ""
    @State var deadLift1RM = ""
    @State var shoulderPress1RM = ""
    
    @State var pushupsAmrap = ""
    @State var situpsAmrap = ""
    
    let inputFieldWidth = 0.2
    let minScaleFactor = 0.05
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 10) {
                
                Text("Extra information")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(minScaleFactor);
                
                Text("Pleasse fill in all the following fields")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .minimumScaleFactor(minScaleFactor);
                
                let circumferenceUnit: String = (PersistenceController.shared.getProfile()!.isMetric) ? "cm" : "ft"
                
                VStack(alignment: .center, spacing: 10) {
                    
                    Text("Circumference metrics")
                        .font(.headline)
                    
                    HStack() {
                        Text("Chest circumference")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: 200)
                        InputDecimalNumberField(placeHolder: circumferenceUnit, numberText: $chestCirc, markAsWrong: false, width: inputFieldWidth)
                    }
                    HStack() {
                        Text("Waist circumference")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: 200)
                        InputDecimalNumberField(placeHolder: circumferenceUnit, numberText: $waistCirc, markAsWrong: false, width: inputFieldWidth)
                    }
                    HStack() {
                        Text("Thigh circumference")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: 200)
                        InputDecimalNumberField(placeHolder: circumferenceUnit, numberText: $thighCirc, markAsWrong: false, width: inputFieldWidth)
                    }
                    HStack() {
                        Text("Calf circumference")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: 200)
                        InputDecimalNumberField(placeHolder: circumferenceUnit, numberText: $calfCirc, markAsWrong: false, width: inputFieldWidth)
                    }
                    HStack() {
                        Text("Lower arm circumference")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: 200)
                        InputDecimalNumberField(placeHolder: circumferenceUnit, numberText: $lowerArmCirc, markAsWrong: false, width: inputFieldWidth)
                    }
                    HStack() {
                        Text("Upper arm circumference")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: 200)
                        InputDecimalNumberField(placeHolder: circumferenceUnit, numberText: $upperArmCirc, markAsWrong: false, width: inputFieldWidth)
                    }
                    
                }
                .padding(.top, 40)
                
                let oneRepMaxUnit: String = (PersistenceController.shared.getProfile()!.isMetric) ? "kg" : "lbs"
                
                VStack(alignment: .center, spacing: 10) {
                    
                    Text("One rep max's")
                        .font(.headline)
                    
                    HStack() {
                        Text("Benchpress")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: 200)
                        InputDecimalNumberField(placeHolder: oneRepMaxUnit, numberText: $benchPress1RM, markAsWrong: false, width: inputFieldWidth)
                    }
                    HStack() {
                        Text("Squats")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: 200)
                        InputDecimalNumberField(placeHolder: oneRepMaxUnit, numberText: $squat1RM, markAsWrong: false, width: inputFieldWidth)
                    }
                    HStack() {
                        Text("Shoulderpress")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: 200)
                        InputDecimalNumberField(placeHolder: oneRepMaxUnit, numberText: $shoulderPress1RM, markAsWrong: false, width: inputFieldWidth)
                    }
                    HStack() {
                        Text("Deadlift")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: 200)
                        InputDecimalNumberField(placeHolder: oneRepMaxUnit, numberText: $deadLift1RM, markAsWrong: false, width: inputFieldWidth)
                    }
                }
                .padding(.top, 40)
                
                VStack(alignment: .center, spacing: 10) {
                    
                    Text("AMRAP's")
                        .font(.headline)
                    
                    HStack() {
                        Text("Pushups")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: 200)
                        InputIntegerNumberField(placeHolder: "reps", numberText: $pushupsAmrap, markAsWrong: false, width: inputFieldWidth)
                    }
                    HStack() {
                        Text("Situps")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: 200)
                        InputIntegerNumberField(placeHolder: "reps", numberText: $situpsAmrap, markAsWrong: false, width: inputFieldWidth)
                    }
                }
                .padding(.top, 40)
            }
        }
    }
}

#Preview {
    CreateNewProfile3()
        .environmentObject(ViewRouter())
}
