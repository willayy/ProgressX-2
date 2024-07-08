//
//  EditExercise.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-05-16.
//

import SwiftUI
import CoreData

struct EditExerciseView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    // Fetch Exercises to check if exercise name is taken
    @FetchRequest(
        entity: Exercise.entity(),
        sortDescriptors: []
    ) private var exercises: FetchedResults<Exercise>
    
    @Binding var selectedExercise: Exercise?
    @StateObject private var viewModel = EditExerciseViewModel()
    
    var body: some View {
            ScrollView {
                VStack(alignment: .center) {
                    BoldTitle(
                        text: "Editing exercise: \(selectedExercise!.exerciseName!)"
                    )
                        
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
                    } else {
                        LightSubHeadline(text: selectedExercise!.exerciseDesc!)
                            .padding(.bottom, 20)
                    }
                    
                    InputTextField(
                        placeHolder: "New exercise name",
                        text: $viewModel.newName,
                        maxChars: 25,
                        markAsWrong: $viewModel.newNameIsInvalid,
                        width: 0.6,
                        errorMessage: $viewModel.newNameIsInvalidMsg
                    )
                    .padding(.bottom, 10)
                        
                    InputTextField(
                        placeHolder: "new exercise description",
                        text: $viewModel.newDesc,
                        maxChars: 200,
                        markAsWrong: $viewModel.newDescIsInvalid,
                        width: 0.6,
                        errorMessage: $viewModel.newDescIsInvalidMsg
                    )
                    .padding(.bottom, 20)
                    
                    // MARK: Handle an edit of an exercise
                    Button(action: {
                        if validateInput() {
                            viewModel.saveExerciseChanges(selectedExercise: selectedExercise)
                        }
                    }) {
                        Text("Save changes")
                            .frame(height: 40)
                        Image(systemName: "square.and.arrow.down")
                    }
                    .buttonStyle(BorderedProminentButtonStyle())
            }
        }
        .onAppear(perform: {
            viewModel.setViewStartValues(selectedExercise: selectedExercise)
        })
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
