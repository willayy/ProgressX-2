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
    
    @State private var showRoutineChangedAlert: Bool = false
    @State private var showNoChangeAlert: Bool = false
    @State private var showChangeInfo: Bool = false
    
    @State private var editedRoutineName: String = ""
    @State private var editedRoutineNameIsInvalid: Bool = false
    @State private var editedRoutineNameIsInvalidMsg: String = ""
    
    @State private var editiedRoutineDescription: String = ""
    @State private var editedRoutineDescIsInvalid: Bool = false
    @State private var editedRoutineDescIsInvalidMsg: String = ""
    
    @Binding var navPath: [Int]
    @Binding var selectedRoutine: Routine?
    @Binding var selectedTemplateCycle: TemplateCycle?
    @Binding var selectedTemplateWeek: TemplateWeek?
    
    var body: some View {

        // Get the templateWeeks for this routine.

        @FetchRequest(
            entity: TemplateWeek.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \TemplateWeek.positionIndex, ascending: true)],
            predicate: NSPredicate(format: "cycle == %@", selectedTemplateCycle!)
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
                        showChangeInfo.toggle()
                    }
                } label: {
                    BoldSubHeadline(text: "Change routine informaton")
                        .frame(width: 240)
                }.buttonStyle(BorderedButtonStyle())
                
                if showChangeInfo {
                    VStack {
                        if showRoutineChangedAlert {
                            SubmitAlert(message: "Successfully edited routine!", color: .green, showAlertState: $showRoutineChangedAlert)
                        } else if showNoChangeAlert {
                            SubmitAlert(message: "No change!", color: .blue, showAlertState: $showNoChangeAlert)
                        }
                        
                        InputShortTextField(
                            placeHolder: "New routine name",
                            text: $editedRoutineName,
                            markAsWrong: $editedRoutineNameIsInvalid,
                            width: 0.6,
                            errorMessage: $editedRoutineNameIsInvalidMsg
                        )
                        
                        InputShortTextField(
                            placeHolder: "New routine description",
                            text: $editiedRoutineDescription,
                            markAsWrong: $editedRoutineDescIsInvalid,
                            width: 0.6,
                            errorMessage: $editedRoutineDescIsInvalidMsg
                        )
                        
                        Button {
                            if validateInput() {
                                let inputName = editedRoutineName.isEmpty ? selectedRoutine!.timePeriodName! : editedRoutineName
                                let inputDesc = editiedRoutineDescription.isEmpty ? selectedRoutine!.timePeriodDescription! : editiedRoutineDescription
                                
                                selectedRoutine!.timePeriodName = inputName
                                selectedRoutine!.timePeriodDescription = inputDesc
                                
                                PersistenceController.save(viewContext)
                                
                                if editedRoutineName.isEmpty && editiedRoutineDescription.isEmpty {
                                    withAnimation(.easeOut) {
                                        showNoChangeAlert = true
                                        editedRoutineName = ""
                                        editiedRoutineDescription = ""
                                    }
                                } else {
                                    withAnimation(.easeOut) {
                                        showRoutineChangedAlert = true
                                        editedRoutineName = ""
                                        editiedRoutineDescription = ""
                                    }
                                }
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
                
                Button {
                    let positionIndex = selectedTemplateCycle!.getNextPositionIndex()
                    _ = PersistenceController.createTemplateWeek(
                        viewContext,
                        name: "Week \(positionIndex)",
                        templateCycle: selectedTemplateCycle!, 
                        positionIndex: positionIndex
                    )
                    PersistenceController.save(viewContext)
                } label: {
                    Text("Add new Week")
                        .frame(height: 40)
                    Image(systemName: "plus")
                }
                .buttonStyle(BorderedProminentButtonStyle())
                .padding(.top, 10)
            
            }
        }
    }
    
    private func validateInput() -> Bool {
        var valid: Int = 0
        let routineNameValidator = StringFieldValidator(
            emptyAllowed: true,
            duplicatesAllowed: false,
            checkStrings: routines.map {$0.timePeriodName!}
        )
        let routineDescValidator = StringFieldValidator(emptyAllowed: true)
        
        valid += routineNameValidator.valideField(
            inputVar: editedRoutineName,
            errorMessage: $editedRoutineNameIsInvalidMsg,
            fieldInvalid: $editedRoutineNameIsInvalid
        )
        
        valid += routineDescValidator.valideField(
            inputVar: editiedRoutineDescription,
            errorMessage: $editedRoutineDescIsInvalidMsg,
            fieldInvalid: $editedRoutineDescIsInvalid
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
    @State var selectedTemplateCycle: TemplateCycle? = routine.template
    @State var selectedTemplateWeek: TemplateWeek? = nil
    
    return EditRoutineView(
        navPath: $navPath,
        selectedRoutine: $selectedRoutine, 
        selectedTemplateCycle: $selectedTemplateCycle,
        selectedTemplateWeek: $selectedTemplateWeek
    )
    .environment(\.managedObjectContext, context)
}
