//
//  EditExercise.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-05-16.
//

import SwiftUI

struct EditExercise: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var exercise: Exercise?
    @Binding var currName: String
    @Binding var currDesc: String
    @Binding var exercises: [Exercise]
    
    @State var newName: String = ""
    @State var newDesc: String = ""
    
    @State var newExerciseNameWrong: Bool = false
    
    var body: some View {
            ScrollView {
                VStack(alignment: .center) {
                
                BoldTitle(text: "Editing exercise \(currName)")
                
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
                    
                    if exercises.contains(where: { $0.exerciseName == newName }) {
                        newExerciseNameWrong = true
                        return
                    } else {
                        newExerciseNameWrong = false
                    }
                        
                    currName = newName.isEmpty ? currName : newName
                    currDesc = newDesc.isEmpty ? currDesc : newDesc
                    exercise!
                        .setValue_ch(currName, forKey: "exerciseName")
                        .setValue(currDesc, forKey: "exerciseDesc")
                    DataFetching.save()
                        
                    for i in 0..<exercises.count {
                        if exercises[i].exerciseName == currName {
                            exercises[i] = exercise!
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
}

#Preview {
    let container = PersistenceController.shared.previewContainer
    @State var ex: Exercise? = DataFetching.getExercisesAsArray().first!
    @State var nn: String = "testing exercise"
    @State var nd: String = "This exercise is used for debugging purposes within the canvas preview"
    @State var lst: [Exercise] = DataFetching.getExercisesAsArray()
    
    return EditExercise(exercise: $ex, currName: $nn, currDesc: $nd, exercises: $lst)
            .environment(\.managedObjectContext, container.viewContext)
}
