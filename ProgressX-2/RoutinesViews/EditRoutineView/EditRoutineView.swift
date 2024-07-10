//
//  EditRoutineView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-19.
//

import SwiftUI
import CoreData

struct EditRoutineView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    // To check for already taken routine names
    @FetchRequest(
        entity: Routine.entity(),
        sortDescriptors: []
    ) private var routines: FetchedResults<Routine>
    
    @StateObject private var viewModel = EditRoutineViewModel()
    @Binding var navPath: [Int]
    @Binding var selectedRoutine: Routine?
    @Binding var selectedTemplateCycle: TemplateCycle?
    @Binding var selectedTemplateWeek: TemplateWeek?
    
    var body: some View {

        // Get the templateWeeks for this routine.
        @FetchRequest(
            entity: TemplateWeek.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \TemplateWeek.positionIndex, ascending: true)],
            predicate: NSPredicate(format: "templateCycle == %@", selectedTemplateCycle!)
        ) var templateWeeks: FetchedResults<TemplateWeek>
        
        ScrollView {
            VStack {
                BoldTitle(text: "Editing routine: \(selectedRoutine!.timePeriodName!)")
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                
                BoldSubHeadline(text: "Description:")
                
                // Show red label if description is missing.
                if selectedRoutine!.timePeriodDescription!.isEmpty {
                    Text("No description.")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundStyle(.red)
                        .padding(.bottom, 20)
                } else {
                    LightSubHeadline(text: selectedRoutine!.timePeriodDescription!)
                        .padding(.bottom, 20)
                }
                
                Button {
                    withAnimation {
                        viewModel.showChangeInfo.toggle()
                    }
                } label: {
                    BoldSubHeadline(text: "Change routine informaton")
                        .frame(width: 240)
                }.buttonStyle(BorderedButtonStyle())
                
                if viewModel.showChangeInfo {
                    VStack {
                        if viewModel.showRoutineChangedAlert {
                            SubmitAlert(message: "Successfully edited routine!", color: .green, showAlertState: $viewModel.showRoutineChangedAlert)
                        } else if viewModel.showNoChangeAlert {
                            SubmitAlert(message: "No change!", color: .blue, showAlertState: $viewModel.showNoChangeAlert)
                        }
                        
                        InputTextField(
                            placeHolder: "New routine name",
                            text: $viewModel.editedRoutineName, 
                            maxChars: 25,
                            markAsWrong: $viewModel.editedRoutineNameIsInvalid,
                            width: 0.6,
                            errorMessage: $viewModel.editedRoutineNameIsInvalidMsg
                        )
                        
                        InputTextField(
                            placeHolder: "New routine description",
                            text: $viewModel.editiedRoutineDescription, 
                            maxChars: 200,
                            markAsWrong: $viewModel.editedRoutineDescIsInvalid,
                            width: 0.6,
                            errorMessage: $viewModel.editedRoutineDescIsInvalidMsg
                        )
                        
                        Button {
                            if validateInput() {
                                viewModel.saveRoutineChanges(
                                    viewContext: viewContext,
                                    selectedRoutine: selectedRoutine
                                )
                            }
                        } label: {
                            Text("Save change")
                                .frame(height: 40)
                            Image(systemName: "square.and.arrow.down")
                        }
                        .buttonStyle(BorderedProminentButtonStyle())
                        .padding(.top, 10)
                        
                    }
                }
                    
                BoldSubHeadline(text: "Current Weeks in this routine")
                    .padding(.top, 20)
                
                BasicList(
                    height: 400,
                    containerName: "this Routine",
                    elementName: "week",
                    data: _templateWeeks
                ) { week in
                    TemplateWeekListItem(
                        navPath: $navPath,
                        selectedTemplateWeek: $selectedTemplateWeek,
                        week: week
                    )
                    .environment(\.managedObjectContext, viewContext)
                }
                .padding(.horizontal, 10)
                
                Button {
                    viewModel.addWeek(
                        viewContext: viewContext,
                        selectedTemplateCycle: selectedTemplateCycle
                    )
                } label: {
                    Text("Add new Week")
                        .frame(height: 40)
                    Image(systemName: "plus")
                }
                .buttonStyle(BorderedProminentButtonStyle())
                .padding(.top, 20)
                .padding(.bottom, 10)
            
            }
        }
        .onAppear(perform: {
            viewModel.setViewStartValues(selectedRoutine: selectedRoutine)
        })
    }
    
    private func validateInput() -> Bool {
        var valid: Int = 0
        
        // Get all routine names and remove the selected routines name
        var checkStrings = routines.map {$0.timePeriodName!}
        checkStrings.removeAll(where: {$0 == selectedRoutine!.timePeriodName})
        
        let routineNameValidator = StringFieldValidator(
            duplicatesAllowed: false,
            checkStrings: checkStrings
        )
        
        let routineDescValidator = StringFieldValidator(emptyAllowed: true)
        
        valid += routineNameValidator.valideField(
            inputVar: viewModel.editedRoutineName,
            errorMessage: $viewModel.editedRoutineNameIsInvalidMsg,
            fieldInvalid: $viewModel.editedRoutineNameIsInvalid
        )
        
        valid += routineDescValidator.valideField(
            inputVar: viewModel.editiedRoutineDescription,
            errorMessage: $viewModel.editedRoutineDescIsInvalidMsg,
            fieldInvalid: $viewModel.editedRoutineDescIsInvalid
        )

        return valid == 0
    }
    
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let fetchRequest: NSFetchRequest = Routine.fetchRequest()
    let routines = PersistenceController.fetch(context, fetchRequest: fetchRequest)
    
    let routine = routines.first!
    
    @State var navPath: [Int] = [Int]()
    @State var selectedRoutine: Routine? = routine
    @State var selectedTemplateCycle: TemplateCycle? = routine.templateCycle
    @State var selectedTemplateWeek: TemplateWeek? = nil
    
    return EditRoutineView(
        navPath: $navPath,
        selectedRoutine: $selectedRoutine, 
        selectedTemplateCycle: $selectedTemplateCycle,
        selectedTemplateWeek: $selectedTemplateWeek
    )
    .environment(\.managedObjectContext, context)
}
