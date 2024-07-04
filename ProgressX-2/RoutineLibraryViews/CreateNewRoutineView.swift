//
//  CreateNewRoutine.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-19.
//

import SwiftUI

struct CreateNewRoutineView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var navPath: [Int]
    @Binding var selectedRoutine: Routine?
    @Binding var selectedTemplateCycle: TemplateCycle?
    
    @FetchRequest(
        entity: Routine.entity(),
        sortDescriptors: []
    ) var routines: FetchedResults<Routine>
    
    @State private var newRoutineName: String = ""
    @State private var newRoutineNameIsInvalid: Bool = false
    @State private var newRoutineNameIsInvalidMsg: String = ""
    
    @State private var newRoutineDesc: String = ""
    @State private var newRoutineDescIsInvalid: Bool = false
    @State private var newRoutineDescIsInvalidMsg: String = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                
                BoldTitle(text: "Create new routine")
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
                
                Button {
                    if validateInput() {
                        // Create a Routine
                        let newRoutine = Routine(context: viewContext)
                        newRoutine.timePeriodName = newRoutineName
                        newRoutine.timePeriodDescription = newRoutineDesc
                        newRoutine.createdOnDate = Date()
                        let templateCycle = TemplateCycle(context: viewContext)
                        templateCycle.timePeriodName = newRoutineName
                        templateCycle.routine = newRoutine
                        newRoutine.templateCycle = templateCycle
                        
                        // reset fields
                        withAnimation {
                            newRoutineName = ""
                            newRoutineDesc = ""
                        }
                        
                        // Save and continue
                        PersistenceController.save(viewContext)
                        selectedRoutine = newRoutine
                        selectedTemplateCycle = templateCycle
                        navPath.append(2)
                    }
                } label: {
                    Text("Save and continue")
                        .frame(height: 40)
                    Image(systemName: "arrow.right")
                }
                .buttonStyle(BorderedProminentButtonStyle())
                
                
            }
        }
    }
    
    private func validateInput() -> Bool {
        var valid: Int = 0
        let nameValidator = StringFieldValidator(duplicatesAllowed: false, checkStrings: routines.map { $0.timePeriodName! })
        let descValidator = StringFieldValidator(emptyAllowed: true)
        valid += nameValidator.valideField(inputVar: newRoutineName, errorMessage: $newRoutineNameIsInvalidMsg, fieldInvalid: $newRoutineNameIsInvalid)
        valid += descValidator.valideField(inputVar: newRoutineDesc, errorMessage: $newRoutineDescIsInvalidMsg, fieldInvalid: $newRoutineDescIsInvalid)
        return valid == 0
    }
    
}

#Preview {
    @State var navPath: [Int] = [Int]()
    @State var selectedRoutine: Routine? = nil
    @State var selectedTemplateCycle: TemplateCycle? = nil
    
    return CreateNewRoutineView(
        navPath: $navPath,
        selectedRoutine: $selectedRoutine,
        selectedTemplateCycle: $selectedTemplateCycle
    )
}
