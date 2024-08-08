//
//  CreateNewRoutine.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-19.
//

import SwiftUI

struct CreateNewRoutineView: View {
    
    @FetchRequest(
        entity: Routine.entity(),
        sortDescriptors: []
    ) var routines: FetchedResults<Routine>
    
    @Binding var navPath: [Int]
    @Binding var selectedRoutine: Routine?
    @Binding var selectedTemplateCycle: TemplateCycle?
    @StateObject private var viewModel = CreateNewRoutineViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        ScrollView {
            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                
                BoldTitle(text: "Create new routine")
                    .padding(.bottom, 10)
                    .padding(.horizontal, 20)
                
                LightSubHeadline(text: "Start by giving your new routine a name and optionally a description.")
                    .padding(.bottom, 20)
                    .padding(.horizontal, 20)
                
                InputTextField(
                    placeHolder: "Routine name",
                    text: $viewModel.newRoutineName,
                    markAsWrong: $viewModel.newRoutineNameIsInvalid,
                    errorMessage: $viewModel.newRoutineNameIsInvalidMsg,
                    maxChars: 25
                )
                .padding(.horizontal, 60)
                .padding(.bottom, 10)
                
                HiddenLightSubHeadline(
                    title: "Why have a description?",
                    text: "Describing routines, or anything else for that matter, is optional in ProgressX. If you choose to use it, it should be used as a way to provide some more information about the routine in a way that can't be dont by it's title.",
                    alignment: .leading
                )
                .padding(.horizontal, 20)
                
                inputLongTextField(
                    placeHolder: "Routine description",
                    text: $viewModel.newRoutineDesc,
                    markAsWrong: $viewModel.newRoutineDescIsInvalid,
                    errorMessage: $viewModel.newRoutineDescIsInvalidMsg,
                    maxChars: 200
                )
                .frame(height: 150)
                .padding(.horizontal, 60)
                .padding(.bottom, 20)
                
                Button {
                    if validateInput() {
                        viewModel.saveEntry(viewContext: viewContext)
                        navPath.removeLast()
                    }
                } label: {
                    Text("Create new routine")
                        .frame(height: 40)
                        .foregroundColor(Color("buttonTextColor"))
                    Image(systemName: "plus")
                        .foregroundColor(Color("buttonTextColor"))
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
