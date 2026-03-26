//
//  CreateNewProfile4.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-14.
//

import SwiftUI

struct CreateNewProfile4View: View {
    
    // Fetch all the generated exerices so PR's can be added
    @FetchRequest(
        entity: Exercise.entity(),
        sortDescriptors: []
    ) private var exercises: FetchedResults<Exercise>
    
    // Fetch all PersonalRecords to ensure this View doesnt produce more than one set of PersonalRecords for the starting exercises. At this state in the app the only PersonalRecords are the ones created in this View.
    @FetchRequest(
        entity: PersonalRecord.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \PersonalRecord.achievedOnDate, ascending: true)]
    ) private var personalRecords: FetchedResults<PersonalRecord>
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var navPath: [Int]
    
    @StateObject private var viewModel = CreateNewProfile4ViewModel()
    
    var body: some View {
            
        ScrollView(showsIndicators: false) {
            
            VStack(alignment: .center, spacing: 10) {
                
                Text("Extra information on basic exercises")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(viewModel.minScaleFactor);
                
                Text("Please fill in all the following fields of personal records for some basic exercises, these are only your initial PR's for these exercises. You can add more PR's later!")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .minimumScaleFactor(viewModel.minScaleFactor);
                
                // MARK: Inputs for 1RM PR's
                VStack(alignment: .center, spacing: 10) {
                    
                    Text("One rep max's")
                        .font(.headline)
                    
                    HiddenLightSubHeadline(title: "I dont know what to write here?", text: "If you dont know what your one rep max (the maximum amount of weight you can lift for a single repetition of a specific exercise) is on some of these exercises just try to approximate it, preferably on the lower side.")
                    
                    HStack {
                        
                        Text("Bench press")
                            .minimumScaleFactor(viewModel.minScaleFactor)
                            .frame(
                                width: viewModel.textWidth,
                                alignment: .leading
                            )
                        
                        Spacer(minLength: 50)
                        
                        InputField(
                            placeHolder: viewModel.weightUnit(viewContext),
                            text: $viewModel.benchPress1RM,
                            variant: DecimalIF(
                                min: 1,
                                max: 10000
                            )
                        )
                        
                    }
                    
                    HStack {
                        
                        Text("Shoulder press")
                            .minimumScaleFactor(viewModel.minScaleFactor)
                            .frame(
                                width: viewModel.textWidth,
                                alignment: .leading
                            )
                        
                        Spacer(minLength: 50)
                        
                        InputField(
                            placeHolder: viewModel.weightUnit(viewContext),
                            text: $viewModel.shoulderPress1RM,
                            variant: DecimalIF(
                                min: 1,
                                max: 10000
                            )
                        )
                        
                    }
                    
                    HStack {
                        
                        Text("Squats")
                            .minimumScaleFactor(viewModel.minScaleFactor)
                            .frame(
                                width: viewModel.textWidth,
                                alignment: .leading
                            )
                        
                        Spacer(minLength: 50)
                        
                        InputField(
                            placeHolder: viewModel.weightUnit(viewContext),
                            text: $viewModel.squat1RM,
                            variant: DecimalIF(
                                min: 1,
                                max: 10000
                            )
                        )
                        
                    }
                    
                    HStack {
                        
                        Text("Deadlift")
                            .minimumScaleFactor(viewModel.minScaleFactor)
                            .frame(
                                width: viewModel.textWidth,
                                alignment: .leading
                            )
                        
                        Spacer(minLength: 50)
                        
                        InputField(
                            placeHolder: viewModel.weightUnit(viewContext),
                            text: $viewModel.deadLift1RM,
                            variant: DecimalIF(
                                min: 1,
                                max: 10000
                            )
                        )
                        
                    }
                    
                    HStack {
                        
                        Text("Barbell row")
                            .minimumScaleFactor(viewModel.minScaleFactor)
                            .frame(
                                width: viewModel.textWidth,
                                alignment: .leading
                            )
                        
                        Spacer(minLength: 50)
                        
                        InputField(
                            placeHolder: viewModel.weightUnit(viewContext),
                            text: $viewModel.barbellRow1RM,
                            variant: DecimalIF(
                                min: 1,
                                max: 10000
                            )
                        )
                        
                    }
                    
                    HStack {
                        
                        Text("Overhead tricep extension")
                            .minimumScaleFactor(viewModel.minScaleFactor)
                            .frame(
                                width: viewModel.textWidth,
                                alignment: .leading
                            )
                        
                        Spacer(minLength: 50)
                        
                        InputField(
                            placeHolder: viewModel.weightUnit(viewContext),
                            text: $viewModel.overheadTriExt1RM,
                            variant: DecimalIF(
                                min: 1,
                                max: 10000
                            )
                        )
                        
                    }
                    
                    HStack {
                        
                        Text("Dumbbell curl")
                            .minimumScaleFactor(viewModel.minScaleFactor)
                            .frame(
                                width: viewModel.textWidth,
                                alignment: .leading
                            )
                        
                        Spacer(minLength: 50)
                        
                        InputField(
                            placeHolder: viewModel.weightUnit(viewContext),
                            text: $viewModel.dumbbellCurl1RM,
                            variant: DecimalIF(
                                min: 1,
                                max: 10000
                            )
                        )
                        
                    }
                    
                }
                .padding(.horizontal, 55)
                .padding(.top, 20)
                
                // MARK: Inputs for AMRAP PR's
                VStack(alignment: .center, spacing: 10) {
                    
                    Text("AMRAP's")
                        .font(.headline)
                    
                    HiddenLightSubHeadline(title: "What is AMRAP?", text: "AMRAP means as many reps as possible. We want to know how many reps you can achieve doing these following exercises with only your bodyweight.")
                    
                    HStack {
                        
                        Text("Push-up")
                            .minimumScaleFactor(viewModel.minScaleFactor)
                            .frame(
                                width: viewModel.textWidth,
                                alignment: .leading
                            )
                        
                        Spacer(minLength: 50)
                        
                        InputField(
                            placeHolder: "reps",
                            text: $viewModel.pushupsAmrap,
                            variant: IntegerIF(
                                min: 1,
                                max: 100000
                            )
                        )
                        
                    }
                    
                    HStack {
                        
                        Text("Sit-up")
                            .minimumScaleFactor(viewModel.minScaleFactor)
                            .frame(
                                width: viewModel.textWidth,
                                alignment: .leading
                            )
                        
                        Spacer(minLength: 50)
                        
                        InputField(
                            placeHolder: "reps",
                            text: $viewModel.situpsAmrap,
                            variant: IntegerIF(
                                min: 1,
                                max: 100000
                            )
                        )
                        
                    }
                    
                    HStack {
                        
                        Text("Chin-up")
                            .minimumScaleFactor(viewModel.minScaleFactor)
                            .frame(
                                width: viewModel.textWidth,
                                alignment: .leading
                            )
                        
                        Spacer(minLength: 50)
                        
                        InputField(
                            placeHolder: "reps",
                            text: $viewModel.chinupsAmrap,
                            variant: IntegerIF(
                                min: 1,
                                max: 100000
                            )
                        )
                        
                    }
                    
                }
                .padding(.horizontal, 55)
                .padding(.top, 20)
                
            }
            
        }
              
        // MARK: Finish onboarding button
        Button {
            
            if GlobalInputFieldValidator.allFieldsValid() {
                
                viewModel.saveEntry(viewContext: viewContext)
                
                viewModel.generateBasicRoutine(viewContext: viewContext)
                
                withAnimation {
                    
                    viewRouter.startView = .None
                    
                    viewRouter.rootView = .HomeView
                    
                }
                
            }
            
        } label: {
            
            Text("Finish")
                .frame(width: 100, height: 40)
                .foregroundColor(Color("buttonTextColor"))
            
        }
        .buttonStyle(.borderedProminent)
        .padding(.vertical, 20)
        
    }
    
}

#Preview {
    
    let context = PersistenceController.previewViewContext
    
    @State var navPath = [Int]()
    
    return CreateNewProfile4View(navPath: $navPath)
        .environmentObject(ViewRouter())
        .environment(\.managedObjectContext, context)
}
