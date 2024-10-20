//
//  EditExercise.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-05-16.
//

import SwiftUI
import CoreData

struct EditExerciseView: View {
    
    // Fetch Exercises to check if exercise name is taken
    @FetchRequest(
        entity: Exercise.entity(),
        sortDescriptors: []
    ) private var exercises: FetchedResults<Exercise>
    
    // Fetch all categories so you can edit which ones are set to this exercise
    @FetchRequest(
        entity: ExerciseCategory.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ExerciseCategory.categoryName, ascending: false)]
    ) private var categories: FetchedResults<ExerciseCategory>
    
    @Binding var selectedExercise: Exercise?
    
    @StateObject private var viewModel = EditExerciseViewModel()
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
                    
        ScrollView {
                
            BoldTitle(text: "Editing")
            
            // Code that is triggered when the view appears.
            Title2(text: "\(selectedExercise!.exerciseName!)")
                .onAppear(perform: {
                    
                    viewModel.setViewStartValues(entity: selectedExercise!)
                    
                })
            
            // MARK: Submission alert state
            if viewModel.exerciseEditedAlert {
                
                SubmitAlert(
                    message: "Succesfully edited Exercise!",
                    color: .green,
                    showAlertState: $viewModel.exerciseEditedAlert
                )
                .padding(.top, 10)
                
            } else if viewModel.noChangeAlert {
                
                SubmitAlert(
                    message: "No changes to Exercise",
                    color: .blue,
                    showAlertState: $viewModel.noChangeAlert
                )
                .padding(.top, 10)
                
            }
            
            // MARK: Dynamic label showing the exercises description in the title
            BoldSubHeadline(text: "Description: ")
                .padding(.top, 10)
            
            if selectedExercise!.exerciseDesc!.isEmpty {
                
                Text("No description.")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundStyle(.red)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 20)
                
            } else {
                
                LightSubHeadline(text: selectedExercise!.exerciseDesc!)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 20)
                
            }
            
            // MARK: Edit exercise name
            BoldSubHeadline(text: "Edit exercise name")
            
            InputField(
                placeHolder: "Exercise name",
                text: $viewModel.newName,
                variant: TextIF()
            )
            .padding(.horizontal, 60)
            .padding(.bottom, 10)
            
            // MARK: Edit exercise description
            BoldSubHeadline(text: "Edit exercise description")
            
            LargeInputField(
                placeHolder: "No exercise description",
                text: $viewModel.newDesc,
                variant: TextIF(allowEmpty: true)
            )
            .frame(height: 150)
            .padding(.horizontal, 60)
            .padding(.bottom, 10)
            
            // MARK: Edit exercise categories
            BoldSubHeadline(text: "Edit exercise categories")
            
            SelectCategoriesList(
                selectedCategories: $viewModel.selectedCategories,
                categories: _categories
            )
            .padding(.horizontal, 40)

            DisplayMusclesDummy(selectedMuscles: $viewModel.selectedCategories, categories: _categories)
       
        }

        // MARK: Handle an edit of an exercise
        Button(action: {
            
            if GlobalInputFieldValidator.allFieldsValid() {
                
                viewModel.saveEdits(entity: selectedExercise!, viewContext: viewContext)
                
            }
            
        }) {
            
            Text("Save changes")
                .frame(height: 40)
                .foregroundColor(Color("buttonTextColor"))
            
            Image(systemName: "square.and.arrow.down")
                .foregroundColor(Color("buttonTextColor"))
            
        }
        .buttonStyle(BorderedProminentButtonStyle())
        .padding(.vertical, 20)

    }
        
}

#Preview {
    
    let context = PersistenceController.previewViewContext
    
    let fetchRequestRepBasedExercise: NSFetchRequest<Exercise> = Exercise.fetchRequest()
    
    let exerciseResults: [Exercise] = CoreDataAccess.fetch(context, fetchRequest: fetchRequestRepBasedExercise)
    
    @State var ex: Exercise? = exerciseResults.first
    
    return EditExerciseView(selectedExercise: $ex)
            .environment(\.managedObjectContext, context)
}
