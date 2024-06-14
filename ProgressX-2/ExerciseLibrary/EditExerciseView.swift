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
    @State private var newName: String = ""
    @State private var newDesc: String = ""
    @State private var newNameIsInvalid: Bool = false
    @State private var newNameIsInvalidMsg: String = ""
    
    private func showExerciseEditedAlet() -> some View {
        Text("Succesfully edited exercise")
            .fontWeight(.light)
            .foregroundStyle(.green)
            .padding(.bottom, 10)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    withAnimation {
                        exerciseEditedAlert = false
                    }
                }
            }
    }
    
    var body: some View {
            ScrollView {
                VStack(alignment: .center) {
                
                BoldTitle(
                    text: "Editing exercise \(exercise!.exerciseName!)"
                )
                    
                if exerciseEditedAlert {
                    showExerciseEditedAlet()
                }
                
                (Text("Description: ")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                 + Text("\(exercise!.exerciseDesc!)")
                    .fontWeight(.light)
                    .foregroundColor(.black))
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.5)
                    .padding()
                
                InputShortTextField(
                    placeHolder: "New exercise name",
                    text: $newName,
                    markAsWrong: $newNameIsInvalid,
                    width: 0.6,
                    errorMessage: $newNameIsInvalidMsg
                )
                    
                TextField("New exercise description", text: $newDesc)
                    .frame(width: UIScreen.main.bounds.width * 0.6, height: 50)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 10)
                
                // MARK: Handle an edit of an exercise
                Button(action: {
                    if validateInput() {
                        let inputName = newName.isEmpty ? exercise!.exerciseName! : newName
                        let inputDesc = newDesc.isEmpty ? exercise!.exerciseDesc! : newDesc
                        exercise!.exerciseName = inputName
                        exercise!.exerciseDesc = inputDesc
                        PersistenceController.save(viewContext)
                        withAnimation {exerciseEditedAlert = true}
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
        var valid: Bool
        
        // Special case for already taken names
        valid = {
            if (exercises.contains { $0.exerciseName == newName }) {
                newNameIsInvalid = true
                newNameIsInvalidMsg = "This Exercise name is already taken!"
                return false
            } else {
                newNameIsInvalid = false
                newNameIsInvalidMsg = ""
                return true
            }
        }()
        
        let stringFieldValidator = StringFieldValidator(emptyAllowed: true)
        valid = stringFieldValidator.valideField(inputVar: newName, errorMessage: $newNameIsInvalidMsg, fieldInvalid: $newNameIsInvalid)
        
        return valid
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
