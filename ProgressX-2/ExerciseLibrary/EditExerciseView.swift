//
//  EditExercise.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-05-16.
//

import SwiftUI

struct EditExerciseView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var exercise: Exercise?
    @Binding var currName: String
    @Binding var currDesc: String
    @Binding var allExercises: [Exercise]
    @State private var newName: String = ""
    @State private var newDesc: String = ""
    @State private var newExerciseNameWrong: Bool = false
    @State private var exerciseEditedAlert = false
    
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
                
                BoldTitle(text: "Editing exercise \(currName)")
                    
                if exerciseEditedAlert {
                    showExerciseEditedAlet()
                }
                
                (Text("Description: ")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                + Text("\(currDesc)")
                    .fontWeight(.light)
                    .foregroundColor(.black))
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.5)
                    .padding()
                
                InputShortTextField(placeHolder: "New exercise name", text: $newName, markAsWrong: $newExerciseNameWrong, width: 0.6, errorMessage: "This name is already taken!")
                
                TextField("New exercise description", text: $newDesc)
                    .frame(width: UIScreen.main.bounds.width * 0.6, height: 50)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 10)
                
                // MARK: Handle an edit of an exercise
                Button(action: {
                    
                    if allExercises.contains(where: { $0.exerciseName == newName }) {
                        withAnimation{newExerciseNameWrong = true}
                        return
                    } else {
                        withAnimation{newExerciseNameWrong = false}
                    }
                        
                    currName = newName.isEmpty ? currName : newName
                    currDesc = newDesc.isEmpty ? currDesc : newDesc
                    exercise!
                        .setValue_ch(currName, forKey: "exerciseName")
                        .setValue(currDesc, forKey: "exerciseDesc")
                    DataFetching.save(viewContext)
                        
                    for i in 0..<allExercises.count {
                        if allExercises[i].exerciseName == currName {
                            allExercises[i] = exercise!
                        }
                    }
                    
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
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    @State var ex: Exercise? = DataFetching.getExercisesAsArray(context).first!
    @State var nn: String = "testing exercise"
    @State var nd: String = "This exercise is used for debugging purposes within the canvas preview"
    @State var lst: [Exercise] = DataFetching.getExercisesAsArray(context)
    
    return EditExerciseView(exercise: $ex, currName: $nn, currDesc: $nd, allExercises: $lst)
            .environment(\.managedObjectContext, context)
}
