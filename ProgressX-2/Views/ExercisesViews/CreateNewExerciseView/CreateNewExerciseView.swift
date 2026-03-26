//
//  CreateNewExercise2.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-05-16.
//

import SwiftUI

struct CreateNewExerciseView: View {
    
    // Fetch Exercises
    @FetchRequest(
        entity: Exercise.entity(),
        sortDescriptors: []
    ) private var exercises: FetchedResults<Exercise>
    
    // All categories that can be selected
    @FetchRequest(
        entity: ExerciseCategory.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ExerciseCategory.categoryName, ascending: false)]
    ) private var categories: FetchedResults<ExerciseCategory>
        
    @StateObject private var viewModel = CreateNewExerciseViewModel()
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding public var navPath: [Int]
    
    var body: some View {
                
        ScrollView {
            
            BoldTitle(text: "Create new exercise")
                .padding(.horizontal, 20)
            
            // MARK: The name of the exercise
            BoldSubHeadline(text: "Exercise name")
                .padding(.top, 10)
            
            InputField(
                placeHolder: "Exercise name",
                text: $viewModel.enteredExerciseName,
                variant: TextIF()
            )
            .padding(.horizontal, 60)
            .padding(.bottom, 10)
            
            // MARK: The description of the exercise
            BoldSubHeadline(text: "Exercise description")
            
            LargeInputField(
                placeHolder: "Exercise description",
                text: $viewModel.enteredExerciseDesc,
                variant: TextIF(allowEmpty: true)
            )
            .frame(height: 150)
            .padding(.horizontal, 60)
            .padding(.bottom, 20)
            
            BoldSubHeadline(text: "Exercise type")
            
            HiddenLightSubHeadline(
                title: "What does exercise type mean?",
                text: "There are two types of exercises in ProgressX, time based exercise and rep based exercises. Time based exercises are exercises which you do a certain amount of time on, like static holds or the \"Plank\". Rep based exercsies are exercises where you do a certain amount of repetitions, like bench press or squats.",
                alignment: .leading
            )
            .padding(.horizontal, 30)
            
            BasicSegPicker(
                selectedSegment: $viewModel.selectedTypeOfExercise,
                segments: viewModel.exerciseTypeOptions
            )
            .padding(.horizontal, 100)
            
            BoldSubHeadline(text: "Add PR for this exercise?")
                .padding(.top, 20)
            
            HiddenLightSubHeadline(
                title: "What are PR's?",
                text: "A PR (personal record) is a dated record of how you performed on an exercise. For rep based exercises the available PR's are AMRAP (As many reps as possible) and 1RM (one rep max). For time based exercise there is only Time-max PR's which is like an AMRAP PR but instead of counting the reps you did it counts the time you did.",
                alignment: .leading
            )
            .padding(.horizontal, 40)
            
            BooleanSegPicker(
                selectedSegment: $viewModel.addPr,
                segments: viewModel.addPrOptions
            )
            .padding(.horizontal, 100)
            .padding(.bottom, 5)
            
            // MARK: Do you want to add a PR for the new exercise
            if viewModel.addPr {
                
                // If rep exercise add segmented picker to chose AMRAP pr or 1RM pr
                if viewModel.selectedTypeOfExercise == "reps" {
                    
                    BasicSegPicker(
                        selectedSegment: $viewModel.selectedTypeOfPr,
                        segments: viewModel.repBasedPrOptions
                    )
                    .padding(.horizontal, 100)
                    .padding(.bottom, 5)
                    
                }
                
                // MARK: PR load
                InputField(
                    placeHolder: "Load (\(viewModel.weightUnit(viewContext))",
                    text: $viewModel.enteredPrWeigtLoad,
                    variant: DecimalIF(
                        min: 0,
                        max: 10000,
                        bwButton: true
                    )
                )
                .padding(.horizontal, 60)
                
                if viewModel.selectedTypeOfExercise == "time" {
                    
                    InputField(
                        placeHolder: "PR time in seconds",
                        text: $viewModel.enteredPrQuantity,
                        variant: DecimalIF(
                            min: 0,
                            max: 100000
                        )
                    )
                    .padding(.horizontal, 60)
                    
                } else if viewModel.selectedTypeOfExercise == "reps" && viewModel.selectedTypeOfPr == "maxreps" {
                    
                    InputField(
                        placeHolder: "PR reps",
                        text: $viewModel.enteredPrQuantity,
                        variant: IntegerIF(
                            min: 0,
                            max: 100000
                        )
                    )
                    .padding(.horizontal, 60)
                    
                } else {
                    
                    GroupBox {
                        
                        LightSubHeadline(text: "Automatically set to 1 for 1RM")
                            .frame(maxWidth: .infinity)
                        
                    }
                    .padding(.horizontal, 60)
                    
                }
                
            }
            
            BoldSubHeadline(text: "Add muscle categories to this exercise?")
                .padding(.top, 15)
            
            SelectCategoriesList(
                selectedCategories: $viewModel.selectedCategories,
                categories: _categories
            )
            .padding(.horizontal, 40)
            
            DisplayMusclesDummy(selectedMuscles: $viewModel.selectedCategories, categories: _categories)
            
        }
            
        
            // MARK: Create new exercise button
            Button(action: {
                
                if GlobalInputFieldValidator.allFieldsValid() {
                    
                    viewModel.saveEntry(viewContext: viewContext)
                    
                    navPath.removeLast()
                    
                }
                
            }) {
                
                Text("Create new exercise")
                    .frame(height: 40)
                    .foregroundColor(Color("buttonTextColor"))
                
                Image(systemName: "plus")
                    .foregroundColor(Color("buttonTextColor"))
                
            }
            .buttonStyle(BorderedProminentButtonStyle())
            .padding(.vertical, 20)
            .onChange(of: viewModel.selectedTypeOfPr, initial: true, {
                
                viewModel.prTypeChanged()
                
            })
            .onChange(of: viewModel.selectedTypeOfExercise, initial: true, {
                
                viewModel.exerciseTypeChanged()
                
            })
        
    }
    
}

#Preview {
    
    let context = PersistenceController.previewViewContext
    
    @State var lst: [Exercise] = [Exercise()]
    
    @State var navPath: [Int] = [Int]()
    
    return CreateNewExerciseView(
                navPath: $navPath
            )
            .environment(\.managedObjectContext, context)
}

