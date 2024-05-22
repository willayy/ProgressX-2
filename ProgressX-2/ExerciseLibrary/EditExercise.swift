//
//  EditExercise.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-05-16.
//

import SwiftUI

struct EditExercise: View {
    
    private let p = PersistenceController.shared
    @Binding var exercise: Exercise?
    @Binding var currName: String
    @Binding var currDesc: String
    @Binding var exercises: [Exercise]
    
    @State var newName: String = ""
    @State var newDesc: String = ""
    
    @State var newExerciseNameWrong: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            ScrollView {
                
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
                
                
                InputShortTextField(placeHolder: "New exercise name", text: $newName, markAsWrong: $newExerciseNameWrong, width: 0.6)

                TextField("New exercise description", text: $newDesc)
                    .frame(width: UIScreen.main.bounds.width * 0.6, height: 50)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
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
                    p.save()
                        
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
    struct Preview: View {
        @State var ex: Exercise? = nil
        @State var nn: String = "Test"
        @State var nd: String = "Test"
        @State var lst: [Exercise] = [Exercise()]
            var body: some View {
                EditExercise(exercise: $ex, currName: $nn, currDesc: $nd, exercises: $lst)
            }
        }
    return Preview()
}
