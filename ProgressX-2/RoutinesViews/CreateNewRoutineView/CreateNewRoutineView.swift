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
    
    @StateObject private var viewModel = CreateNewRoutineViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                
                BoldTitle(text: "Create new routine")
                    .padding(.bottom, 10)
                
                LightSubHeadline(text: "Start by giving your new routine a name and optionally a description.")
                    .padding(.bottom, 20)
                
                InputTextField(
                    placeHolder: "Routine name...",
                    text: $viewModel.newRoutineName,
                    maxChars: 25,
                    markAsWrong: $viewModel.newRoutineNameIsInvalid,
                    width: 0.6,
                    errorMessage: $viewModel.newRoutineNameIsInvalidMsg
                )
                .padding(.bottom, 10)
                
                InputTextField(
                    placeHolder: "Routine description...",
                    text: $viewModel.newRoutineDesc,
                    maxChars: 200,
                    markAsWrong: $viewModel.newRoutineDescIsInvalid,
                    width: 0.6,
                    errorMessage: $viewModel.newRoutineDescIsInvalidMsg
                )
                .padding(.bottom, 20)
                
                Button {
                    if validateInput() {
                        viewModel.createRoutine(
                            viewContext: viewContext,
                            navPath: $navPath,
                            selectedRoutine: $selectedRoutine,
                            selectedTemplateCycle: $selectedTemplateCycle
                        )
                    }
                } label: {
                    Text("Create routine")
                        .frame(height: 40)
                    Image(systemName: "arrow.right")
                }
                .buttonStyle(BorderedProminentButtonStyle())
                .padding(.bottom, 10)
            }
        }
    }
    
    private func validateInput() -> Bool {
        var valid: Int = 0
        
        let nameValidator = StringFieldValidator(
            duplicatesAllowed: false,
            checkStrings: routines.map {
            $0.timePeriodName!
        })
        
        let descValidator = StringFieldValidator(emptyAllowed: true)
        
        valid += nameValidator.valideField(
            inputVar: viewModel.newRoutineName,
            errorMessage: $viewModel.newRoutineNameIsInvalidMsg,
            fieldInvalid: $viewModel.newRoutineNameIsInvalid
        )
        
        valid += descValidator.valideField(
            inputVar: viewModel.newRoutineDesc,
            errorMessage: $viewModel.newRoutineDescIsInvalidMsg,
            fieldInvalid: $viewModel.newRoutineDescIsInvalid
        )
        
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
