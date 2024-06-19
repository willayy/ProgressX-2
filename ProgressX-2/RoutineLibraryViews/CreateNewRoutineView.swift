//
//  CreateNewRoutine.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-19.
//

import SwiftUI

struct CreateNewRoutine: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var navPath: [Int]
    
    @State private var newRoutineName: String = ""
    @State private var newRoutineNameIsInvalid: Bool = false
    @State private var newRoutineNameIsInvalidMsg: String = ""
    
    @State private var newRoutineDesc: String = ""
    @State private var newRoutineDescIsInvalid: Bool = false
    @State private var newRoutineDescIsInvalidMsg: String = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                
                BoldTitle(text: "Create new Routine")
                    .padding(.bottom, 10)
                
                LightSubHeadline(text: "Start by giving your new routine a name and optionally a description.")
                    .padding(.bottom, 20)
                
                InputShortTextField(
                    placeHolder: "Routine name...",
                    text: $newRoutineName,
                    markAsWrong: $newRoutineNameIsInvalid,
                    width: 0.6,
                    errorMessage: $newRoutineNameIsInvalidMsg
                )
                .padding(.bottom, 10)
                
                InputShortTextField(
                    placeHolder: "Routine description...",
                    text: $newRoutineDesc,
                    markAsWrong: $newRoutineDescIsInvalid,
                    width: 0.6,
                    errorMessage: $newRoutineDescIsInvalidMsg
                )
                .padding(.bottom, 20)
                
                
                
                
            }
        }
    }
}

#Preview {
    
    @State var navPath: [Int] = [Int]()
    
    return CreateNewRoutine(navPath: $navPath)
}
