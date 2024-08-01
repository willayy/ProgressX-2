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
                VStack(alignment: .center) {
                    
                    BoldTitle(text: "Editing")
                    
                    Title2(text: "\(selectedExercise!.exerciseName!)")
                        .onAppear(perform: {
                            viewModel.setViewStartValues(selectedExercise: selectedExercise!)
                        })
                        
                    if viewModel.exerciseEditedAlert {
                        SubmitAlert(
                            message: "Succesfully edited Exercise!",
                            color: .green,
                            showAlertState: $viewModel.exerciseEditedAlert
                        )
                    } else if viewModel.noChangeAlert {
                        SubmitAlert(
                            message: "No changes to Exercise",
                            color: .blue,
                            showAlertState: $viewModel.noChangeAlert
                        )
                    }
    
                    BoldSubHeadline(text: "Description: ")
                        .padding(.top, 10)
                    
                    // if description is empty show a red label instead
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
                    
                    BoldSubHeadline(text: "Edit exercise name")
                    
                    InputTextField(
                        placeHolder: "Exercise name",
                        text: $viewModel.newName,
                        markAsWrong: $viewModel.newNameIsInvalid,
                        errorMessage: $viewModel.newNameIsInvalidMsg,
                        maxChars: 30
                    )
                    .padding(.horizontal, 60)
                    .padding(.bottom, 10)
                     
                    BoldSubHeadline(text: "Edit exercise description")
                    
                    inputLongTextField(
                        placeHolder: "Exercise description",
                        text: $viewModel.newDesc,
                        markAsWrong: $viewModel.newDescIsInvalid,
                        errorMessage: $viewModel.newDescIsInvalidMsg,
                        maxChars: 200
                    )
                    .frame(height: 150)
                    .padding(.horizontal, 60)
                    .padding(.bottom, 10)
                    
                    BoldSubHeadline(text: "Edit exercise categories")
                    
                    SelectCategoriesList(
                        selectedCategories: $viewModel.selectedCategories,
                        categories: _categories
                    ).onAppear(perform: {
                        for category in selectedExercise!.categories! {
                            viewModel.selectedCategories.insert(category as! ExerciseCategory)
                        }
                    })
                    
                    // MARK: Handle an edit of an exercise
                    Button(action: {
                        if validateInput() {
                            viewModel.saveExerciseChanges(
                                viewContext: viewContext,
                                selectedExercise: selectedExercise!)
                        }
                    }) {
                        Text("Save changes")
                            .frame(height: 40)
                            .foregroundColor(Color("buttonTextColor"))
                        Image(systemName: "square.and.arrow.down")
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
        
        var checkStrings = exercises.map { $0.exerciseName! }
        checkStrings.removeAll {$0 == selectedExercise!.exerciseName!}
        
        let exerciseNameValidator = StringFieldValidator(duplicatesAllowed: false, checkStrings: checkStrings)
        
        let exerciseDescValidator = StringFieldValidator()
        
        valid += exerciseNameValidator.valideField(
            inputVar: viewModel.newName,
            errorMessage: $viewModel.newNameIsInvalidMsg,
            fieldInvalid: $viewModel.newNameIsInvalid
        )
        
        valid += exerciseDescValidator.valideField(
            inputVar: viewModel.newDesc,
            errorMessage: $viewModel.newDescIsInvalidMsg,
            fieldInvalid: $viewModel.newDescIsInvalid
        )
        
        return valid == 0
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    
    let fetchRequestRepBasedExercise: NSFetchRequest<Exercise> = Exercise.fetchRequest()
    
    let exerciseResults: [Exercise] = PersistenceController.fetch(context, fetchRequest: fetchRequestRepBasedExercise)
    
    @State var ex: Exercise? = exerciseResults.first
    
    return EditExerciseView(selectedExercise: $ex)
            .environment(\.managedObjectContext, context)
}
