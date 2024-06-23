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
    
    @Binding var exercise: Exercise?
    @State private var exerciseEditedAlert: Bool = false
    @State private var noChangeAlert: Bool = false
    @State private var newName: String = ""
    @State private var newDesc: String = ""
    @State private var newNameIsInvalid: Bool = false
    @State private var newNameIsInvalidMsg: String = ""
    @State private var newDescIsInvalid: Bool = false
    @State private var newDescIsInvalidMsg: String = ""
    
    var body: some View {
            ScrollView {
                VStack(alignment: .center) {
                    BoldTitle(
                        text: "Editing exercise: \(exercise!.exerciseName!)"
                    )
                        
                    if exerciseEditedAlert {
                        SubmitAlert(message: "Succesfully edited Exercise!", color: .green, showAlertState: $exerciseEditedAlert)
                    }
                    
                    if noChangeAlert {
                        SubmitAlert(message: "No changes to Exercise", color: .blue, showAlertState: $noChangeAlert)
                    }
                    
                    BoldSubHeadline(text: "Description: ")
                        .padding(.top, 10)
                    
                    LightSubHeadline(text: exercise!.exerciseDesc!)
                        .padding(.bottom, 20)
                    
                    InputShortTextField(
                        placeHolder: "New exercise name",
                        text: $newName,
                        markAsWrong: $newNameIsInvalid,
                        width: 0.6,
                        errorMessage: $newNameIsInvalidMsg
                    )
                    .padding(.bottom, 10)
                        
                    InputShortTextField(
                        placeHolder: "new exercise description",
                        text: $newDesc,
                        markAsWrong: $newDescIsInvalid,
                        width: 0.6,
                        errorMessage: $newDescIsInvalidMsg
                    )
                    .padding(.bottom, 20)
                    
                    // MARK: Handle an edit of an exercise
                    Button(action: {
                        if validateInput() {
                            let inputName = newName.isEmpty ? exercise!.exerciseName! : newName
                            let inputDesc = newDesc.isEmpty ? exercise!.exerciseDesc! : newDesc
                            exercise!.exerciseName = inputName
                            exercise!.exerciseDesc = inputDesc
                            
                            PersistenceController.save(viewContext)
                            
                            if newName.isEmpty && newDesc.isEmpty {
                                withAnimation(.easeOut) {
                                    noChangeAlert = true
                                    newName = ""
                                    newDesc = ""
                                }
                            } else {
                                withAnimation(.easeOut) {
                                    exerciseEditedAlert = true
                                    newName = ""
                                    newDesc = ""
                                }
                            }
                        }
                    }) {
                        Text("Save changes")
                            .frame(height: 40)
                        Image(systemName: "square.and.arrow.down")
                    }
                    .buttonStyle(BorderedProminentButtonStyle())
            }
        }
    }
        
    private func validateInput() -> Bool {
        var valid: Int = 0
        let exerciseNameValidator = StringFieldValidator(emptyAllowed: true, duplicatesAllowed: false, checkStrings: exercises.map { $0.exerciseName! })
        let exerciseDescValidator = StringFieldValidator(emptyAllowed: true)
        valid += exerciseNameValidator.valideField(inputVar: newName, errorMessage: $newNameIsInvalidMsg, fieldInvalid: $newNameIsInvalid)
        valid += exerciseDescValidator.valideField(inputVar: newDesc, errorMessage: $newDescIsInvalidMsg, fieldInvalid: $newDescIsInvalid)
        
        return valid == 0
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    
    let fetchRequestRepBasedExercise: NSFetchRequest<Exercise> = Exercise.fetchRequest()
    
    let exerciseResults: [Exercise] = PersistenceController.fetch(context, fetchRequest: fetchRequestRepBasedExercise)
    
    @State var ex: Exercise? = exerciseResults.first
    
    return EditExerciseView(exercise: $ex)
            .environment(\.managedObjectContext, context)
}
