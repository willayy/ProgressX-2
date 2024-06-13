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
    
    // Fetch RepBasedExercises to check if exercise name is taken
    @FetchRequest(
        entity: RepBasedExercise.entity(),
        sortDescriptors: []
    ) private var repBasedExerciseResults: FetchedResults<Exercise>
    
    // Fetch TimeBasedExercises to check if exercise name is taken
    @FetchRequest(
        entity: TimeBasedExercise.entity(),
        sortDescriptors: []
    ) private var timeBasedExerciseResults: FetchedResults<Exercise>
    
    @Binding var exercise: Exercise?
    @State private var exerciseEditedAlert: Bool = false
    @State private var newName: String = ""
    @State private var newDesc: String = ""
    @State private var newNameIsWrong: Bool = false
    @State private var exerciseResults: [Exercise] = []
    
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
                
                    BoldTitle(text: "Editing exercise \(exercise!.exerciseName!)")
                    
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
                
                InputShortTextField(placeHolder: "New exercise name", text: $newName, markAsWrong: $newNameIsWrong, width: 0.6, errorMessage: "This name is already taken!")
                    
                TextField("New exercise description", text: $newDesc)
                    .frame(width: UIScreen.main.bounds.width * 0.6, height: 50)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 10)
                
                // MARK: Handle an edit of an exercise
                Button(action: {
                    
                    if exerciseResults.contains(where: { $0.exerciseName == newName }) {
                        withAnimation{newNameIsWrong = true}
                        return
                    } else {
                        withAnimation{newNameIsWrong = false}
                    }
                        
                    let inputName = newName.isEmpty ? exercise!.exerciseName! : newName
                    let inputDesc = newDesc.isEmpty ? exercise!.exerciseDesc! : newDesc
                    exercise!.exerciseName = inputName
                    exercise!.exerciseDesc = inputDesc
                    PersistenceController.save(viewContext)
                    
                    withAnimation {
                        exerciseEditedAlert = true
                    }
                    
                }) {
                    Text("Save changes")
                        .frame(height: 40)
                    Image(systemName: "square.and.arrow.down")
                }
                .buttonStyle(BorderedProminentButtonStyle())
                
            }
        }.onAppear(perform: {
            exerciseResults.append(contentsOf: repBasedExerciseResults)
            exerciseResults.append(contentsOf: timeBasedExerciseResults)
        })
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    
    let fetchRequestRepBasedExercise: NSFetchRequest<RepBasedExercise> = RepBasedExercise.fetchRequest()
    
    let exerciseResults: [RepBasedExercise] = PersistenceController.fetch(context, fetchRequest: fetchRequestRepBasedExercise)
    
    @State var ex: Exercise? = exerciseResults.first
    
    return EditExerciseView(exercise: $ex)
            .environment(\.managedObjectContext, context)
}
