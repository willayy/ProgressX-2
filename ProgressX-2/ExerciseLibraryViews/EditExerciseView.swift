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
                        text: "Editing exercise \(exercise!.exerciseName!)"
                    )
                        
                    if exerciseEditedAlert {
                        SubmitAlert(message: "Succesfully edited Exercise!", color: .green, showAlertState: $exerciseEditedAlert)
                    }
                    
                    if noChangeAlert {
                        SubmitAlert(message: "No changes to Exercise", color: .blue, showAlertState: $noChangeAlert)
                    }
                    
                    (Text("Description: ")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                     + Text("\(exercise!.exerciseDesc!)")
                        .fontWeight(.light)
                        .foregroundColor(.black))
                    .padding(.horizontal, 25)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.5)
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
                                withAnimation {
                                    noChangeAlert = true
                                    newName = ""
                                    newDesc = ""
                                }
                            } else {
                                withAnimation {
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
        
        // Special case for already taken names
        valid += {
            if (exercises.contains { $0.exerciseName == newName }) {
                newNameIsInvalid = true
                newNameIsInvalidMsg = "This Exercise name is already taken!"
                return 1
            } else {
                newNameIsInvalid = false
                newNameIsInvalidMsg = ""
                return 0
            }
        }()
        
        let stringFieldValidator = StringFieldValidator(emptyAllowed: true)
        valid += stringFieldValidator.valideField(inputVar: newName, errorMessage: $newNameIsInvalidMsg, fieldInvalid: $newNameIsInvalid)
        valid += stringFieldValidator.valideField(inputVar: newDesc, errorMessage: $newDescIsInvalidMsg, fieldInvalid: $newDescIsInvalid)
        
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
