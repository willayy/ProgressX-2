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
    @Binding var refreshListView: Bool
    @State var newName: String = ""
    @State var newDesc: String = ""
    
    @State var newExerciseNameWrong: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            ScrollView {
                
                Text("Editing exercise \(currName)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.5)
                    .padding()
                
                Text("Description: \(currDesc)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.5)
                    .padding()
                
                InputShortTextField(placeHolder: "New exercise name", text: $newName, markAsWrong: $newExerciseNameWrong, width: 0.6)

                TextField("New exercise description", text: $newDesc)
                    .frame(width: UIScreen.main.bounds.width * 0.6, height: 50)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    if newName.isEmpty {
                        newExerciseNameWrong = true
                    } else {
                        newExerciseNameWrong = false
                        exercise!
                            .setValue_ch(newName, forKey: "exerciseName")
                            .setValue(newDesc, forKey: "exerciseDesc")
                        currName = newName
                        currDesc = newDesc
                        p.save()
                    }
                }) {
                    Text("Save changes")
                        .frame(height: 40)
                    Image(systemName: "square.and.arrow.down")
                }
                .buttonStyle(BorderedProminentButtonStyle())
                
            }
        }.onDisappear(perform: {refreshListView = true})
    }
}

#Preview {
    struct Preview: View {
        @State var ex: Exercise? = nil
        @State var nn: String = "Test"
        @State var nd: String = "Test"
        @State var rf: Bool = false
            var body: some View {
                EditExercise(exercise: $ex, currName: $nn, currDesc: $nd, refreshListView: $rf)
            }
        }
    return Preview()
}
