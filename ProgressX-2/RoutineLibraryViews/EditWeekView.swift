//
//  EditCycleView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-23.
//

import SwiftUI
import CoreData

struct EditWeekView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var showWeekChangedAlert: Bool = false
    @State private var showNoChangeAlert: Bool = false
    @State private var showChangeInfo: Bool = false
    
    @State private var editedWeekName: String = ""
    @State private var editedWeekIsInvalid: Bool = false
    @State private var editedWeekNameIsInvalidMsg: String = ""
    
    @State private var editedWeekDescription: String = ""
    @State private var editedWeekDescIsInvalid: Bool = false
    @State private var editedWeekDescIsInvalidMsg: String = ""
    
    @State private var editedPositionIndex: String = ""
    @State private var editedPositionIndexIsInvalid: Bool = false
    @State private var editedPositionIndexIsInvalidMsg: String = ""
    
    @Binding var navPath: [Int]
    @Binding var selectedTemplateWeek: TemplateWeek?
    @Binding var selectedTemplateSession: TemplateSession?
    
    var body: some View {

        // Get the templateSessions for this week.

        @FetchRequest(
            entity: TemplateSession.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \TemplateSession.positionIndex, ascending: true)],
            predicate: NSPredicate(format: "week == %@", selectedTemplateWeek!)
        ) var templateSessions: FetchedResults<TemplateSession>
        
        ScrollView {
            VStack {
                BoldTitle(text: "Editing week: \(selectedTemplateWeek!.timePeriodName!)")
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                
                BoldSubHeadline(text: "Description:")
                
                // If description is empty replace with a red label.
                if selectedTemplateWeek!.timePeriodDescription!.isEmpty {
                    Text("No description.")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundStyle(.red)
                        .padding(.bottom, 20)
                } else {
                    LightSubHeadline(text: selectedTemplateWeek!.timePeriodDescription!)
                        .padding(.bottom, 20)
                }
                
                // Button that toggles showChangeInfo.
                Button {
                    withAnimation {
                        showChangeInfo.toggle()
                    }
                } label: {
                    BoldSubHeadline(text: "Change week informaton")
                        .frame(width: 240)
                }.buttonStyle(BorderedButtonStyle())
                
                // Expandable hidden view that has functionality for changing name and description.
                if showChangeInfo {
                    VStack {
                        if showWeekChangedAlert {
                            SubmitAlert(message: "Successfully edited week!", color: .green, showAlertState: $showWeekChangedAlert)
                        } else if showNoChangeAlert {
                            SubmitAlert(message: "No change!", color: .blue, showAlertState: $showNoChangeAlert)
                        }
                        
                        InputShortTextField(
                            placeHolder: "New week name",
                            text: $editedWeekName,
                            markAsWrong: $editedWeekIsInvalid,
                            width: 0.6,
                            errorMessage: $editedWeekNameIsInvalidMsg
                        )
                        
                        InputShortTextField(
                            placeHolder: "New week description",
                            text: $editedWeekDescription,
                            markAsWrong: $editedWeekDescIsInvalid,
                            width: 0.6,
                            errorMessage: $editedWeekDescIsInvalidMsg
                        )
                        
                        InputShortTextField(
                            placeHolder: "New position in routine",
                            text: $editedPositionIndex,
                            markAsWrong: $editedPositionIndexIsInvalid,
                            width: 0.6,
                            errorMessage: $editedPositionIndexIsInvalidMsg
                        )
                        
                        Button {
                            if validateInput() {
                                
                                let inputPosition = editedPositionIndex.isEmpty ? selectedTemplateWeek!.positionIndex : Int64(editedPositionIndex)
                                let inputName = editedWeekName.isEmpty ? selectedTemplateWeek!.timePeriodName! : editedWeekName
                                let inputDesc = editedWeekDescription.isEmpty ? selectedTemplateWeek!.timePeriodDescription! : editedWeekDescription
                                
                                // Find the week with the same position index in the parent routine
                                let oldPositionIndex = selectedTemplateWeek!.positionIndex
                                let weeksInParentRoutine: [TemplateWeek] = selectedTemplateWeek!.cycle!.weeks?.allObjects as! [TemplateWeek]
                                let switchWithWeek = weeksInParentRoutine.first(where: { $0.positionIndex == inputPosition })
                                // Switch position index with the week
                                switchWithWeek?.positionIndex = oldPositionIndex
                                
                                selectedTemplateWeek!.positionIndex = inputPosition!
                                selectedTemplateWeek!.timePeriodName = inputName
                                selectedTemplateWeek!.timePeriodDescription = inputDesc
                                
                                PersistenceController.save(viewContext)
                                
                                if editedWeekName.isEmpty && editedWeekDescription.isEmpty && editedPositionIndex.isEmpty {
                                    withAnimation(.easeOut) {
                                        showNoChangeAlert = true
                                        editedWeekName = ""
                                        editedWeekDescription = ""
                                        editedPositionIndex = ""
                                    }
                                } else {
                                    withAnimation(.easeOut) {
                                        showWeekChangedAlert = true
                                        editedWeekName = ""
                                        editedWeekDescription = ""
                                        editedPositionIndex = ""
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
                    
                BoldSubHeadline(text: "Current sessions in this week")
                    .padding(.top, 20)
                
                BasicList(
                    containerName: "this week",
                    elementName: "session",
                    data: _templateSessions
                ) { session in
                    TemplateSessionListItem(
                        navPath: $navPath, 
                        selectedTemplateSession: $selectedTemplateSession,
                        session: session
                    )
                    .environment(\.managedObjectContext, viewContext)
                }
                
                Button {
                    let positionIndex = selectedTemplateWeek!.getNextPositionIndex()
                    _ = PersistenceController.createTemplateSession(
                        viewContext,
                        name: "Session \(positionIndex)",
                        templateWeek: selectedTemplateWeek!,
                        positionIndex: positionIndex
                    )
                    PersistenceController.save(viewContext)
                } label: {
                    Text("Add new Session")
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
        let weeksInParentRoutine: [TemplateWeek] = selectedTemplateWeek!.cycle!.weeks?.allObjects as! [TemplateWeek]
        let maxPositionIndex: Int = Int(weeksInParentRoutine.max {$0.positionIndex > $1.positionIndex}!.positionIndex)
        
        let routineNameValidator = StringFieldValidator(emptyAllowed: true)
        let routineDescValidator = StringFieldValidator(emptyAllowed: true)
        let positionIndexValidator = IntFieldValidator(emptyAllowed: true, minInputNumber: 1, maxInputNumber: maxPositionIndex)
        
        valid += positionIndexValidator.valideField(
            inputVar: editedPositionIndex,
            errorMessage: $editedPositionIndexIsInvalidMsg,
            fieldInvalid: $editedPositionIndexIsInvalid
        )
        
        valid += routineNameValidator.valideField(
            inputVar: editedWeekName,
            errorMessage: $editedWeekNameIsInvalidMsg,
            fieldInvalid: $editedWeekIsInvalid
        )
        
        valid += routineDescValidator.valideField(
            inputVar: editedWeekDescription,
            errorMessage: $editedWeekDescIsInvalidMsg,
            fieldInvalid: $editedWeekDescIsInvalid
        )

        return valid == 0
    }
    
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let fetchRequest: NSFetchRequest = TemplateWeek.fetchRequest()
    let weeks = PersistenceController.fetch(context, fetchRequest: fetchRequest)
    
    let week = weeks.first!
    
    @State var navPath: [Int] = [Int]()
    @State var selectedTemplateWeek: TemplateWeek? = week
    @State var selectedTemplateSession: TemplateSession? = nil
    
    return EditWeekView(
        navPath: $navPath,
        selectedTemplateWeek: $selectedTemplateWeek, 
        selectedTemplateSession: $selectedTemplateSession
    )
    .environment(\.managedObjectContext, context)
}
