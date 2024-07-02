//
//  EditSessionView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-01.
//

import SwiftUI
import CoreData

struct EditSessionView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var selectedThreshold: Threshold? = nil
    
    @State private var showSessionChangedAlert: Bool = false
    @State private var showNoChangeAlert: Bool = false
    @State private var showChangeInfo: Bool = false
    
    @State private var editedSessionName: String = ""
    @State private var editedSessionIsInvalid: Bool = false
    @State private var editedSessionNameIsInvalidMsg: String = ""

    @State private var editedSessionDescription: String = ""
    @State private var editedSessionDescIsInvalid: Bool = false
    @State private var editedSessionDescIsInvalidMsg: String = ""
    
    @State private var editedPositionIndex: String = ""
    @State private var editedPositionIndexIsInvalid: Bool = false
    @State private var editedPositionIndexIsInvalidMsg: String = ""
    
    @Binding var navPath: [Int]
    @Binding var selectedTemplateSet: TemplateSet?
    @Binding var selectedTemplateSession: TemplateSession?
    
    var body: some View {

        // Get the templateSets for this session.
        @FetchRequest(
            entity: TemplateSet.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \TemplateSet.positionIndex, ascending: true)],
            predicate: NSPredicate(format: "session == %@", selectedTemplateSession!)
        ) var templateSets: FetchedResults<TemplateSet>
        
        ScrollView {
            VStack {
                BoldTitle(text: "Editing session: \(selectedTemplateSession!.timePeriodName!)")
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                
                BoldSubHeadline(text: "Description:")
                
                // If description is empty replace with a red label.
                if selectedTemplateSession!.timePeriodDescription!.isEmpty {
                    Text("No description.")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundStyle(.red)
                        .padding(.bottom, 20)
                } else {
                    LightSubHeadline(text: selectedTemplateSession!.timePeriodDescription!)
                        .padding(.bottom, 20)
                }
                
                // Button that toggles showChangeInfo.
                Button {
                    withAnimation {
                        showChangeInfo.toggle()
                    }
                } label: {
                    BoldSubHeadline(text: "Change session informaton")
                        .frame(width: 240)
                }.buttonStyle(BorderedButtonStyle())
                
                // Expandable hidden view that has functionality for changing name and description.
                if showChangeInfo {
                    VStack {
                        if showSessionChangedAlert {
                            SubmitAlert(message: "Successfully edited session!", color: .green, showAlertState: $showSessionChangedAlert)
                        } else if showNoChangeAlert {
                            SubmitAlert(message: "No change!", color: .blue, showAlertState: $showNoChangeAlert)
                        }
                        
                        InputShortTextField(
                            placeHolder: "New session name",
                            text: $editedSessionName,
                            markAsWrong: $editedSessionIsInvalid,
                            width: 0.6,
                            errorMessage: $editedSessionNameIsInvalidMsg
                        )
                        
                        InputShortTextField(
                            placeHolder: "New session description",
                            text: $editedSessionDescription,
                            markAsWrong: $editedSessionDescIsInvalid,
                            width: 0.6,
                            errorMessage: $editedSessionDescIsInvalidMsg
                        )
                        
                        InputShortTextField(
                            placeHolder: "New position in week",
                            text: $editedPositionIndex,
                            markAsWrong: $editedPositionIndexIsInvalid,
                            width: 0.6,
                            errorMessage: $editedPositionIndexIsInvalidMsg
                        )
                        
                        Button {
                            if validateInput() {
                                
                                let inputPosition = editedPositionIndex.isEmpty ? selectedTemplateSession!.positionIndex : Int64(editedPositionIndex)
                                let inputName = editedSessionName.isEmpty ? selectedTemplateSession!.timePeriodName! : editedSessionName
                                let inputDesc = editedSessionDescription.isEmpty ? selectedTemplateSession!.timePeriodDescription! : editedSessionDescription
                                
                                // Find the week with the same position index in the parent routine
                                let oldPositionIndex = selectedTemplateSession!.positionIndex
                                let weeksInParentRoutine: [TemplateSession] = selectedTemplateSession!.week!.sessions?.allObjects as! [TemplateSession]
                                let switchWithSession = weeksInParentRoutine.first(where: { $0.positionIndex == inputPosition })
                                // Switch position index with the week
                                switchWithSession?.positionIndex = oldPositionIndex
                                
                                selectedTemplateSession!.positionIndex = inputPosition!
                                selectedTemplateSession!.timePeriodName = inputName
                                selectedTemplateSession!.timePeriodDescription = inputDesc
                                
                                PersistenceController.save(viewContext)
                                
                                if editedSessionName.isEmpty && editedSessionDescription.isEmpty && editedPositionIndex.isEmpty {
                                    withAnimation(.easeOut) {
                                        showNoChangeAlert = true
                                        editedSessionName = ""
                                        editedSessionDescription = ""
                                        editedPositionIndex = ""
                                    }
                                } else {
                                    withAnimation(.easeOut) {
                                        showSessionChangedAlert = true
                                        editedSessionName = ""
                                        editedSessionDescription = ""
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
                    
                BoldSubHeadline(text: "Current sets in this session")
                    .padding(.top, 20)
                
                // MARK: List of sets
                BasicList(
                    containerName: "this session",
                    elementName: "sets",
                    data: _templateSets
                ) { set in
                    TemplateSetListItem(
                        navPath: $navPath,
                        selectedTemplateSet: $selectedTemplateSet,
                        set: set
                    )
                    .environment(\.managedObjectContext, viewContext)
                }
                
                Button {
                    navPath.append(7)
                } label: {
                    Text("Add new set")
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
        let sessionsInParentRoutine: [TemplateSession] = selectedTemplateSession!.week!.sessions?.allObjects as! [TemplateSession]
        let maxPositionIndex: Int = Int(sessionsInParentRoutine.max {$0.positionIndex > $1.positionIndex}!.positionIndex)
        
        let routineNameValidator = StringFieldValidator(emptyAllowed: true)
        let routineDescValidator = StringFieldValidator(emptyAllowed: true)
        let positionIndexValidator = IntFieldValidator(emptyAllowed: true, minInputNumber: 1, maxInputNumber: maxPositionIndex)
        
        valid += positionIndexValidator.valideField(
            inputVar: editedPositionIndex,
            errorMessage: $editedPositionIndexIsInvalidMsg,
            fieldInvalid: $editedPositionIndexIsInvalid
        )
        
        valid += routineNameValidator.valideField(
            inputVar: editedSessionName,
            errorMessage: $editedSessionNameIsInvalidMsg,
            fieldInvalid: $editedSessionIsInvalid
        )
        
        valid += routineDescValidator.valideField(
            inputVar: editedSessionDescription,
            errorMessage: $editedSessionDescIsInvalidMsg,
            fieldInvalid: $editedSessionDescIsInvalid
        )

        return valid == 0
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let fetchRequest: NSFetchRequest = TemplateSession.fetchRequest()
    let sessions = PersistenceController.fetch(context, fetchRequest: fetchRequest)
    
    let session = sessions.first!
    
    @State var navPath: [Int] = [Int]()
    @State var selectedTemplateSession: TemplateSession? = session
    @State var selectedTemplateSet: TemplateSet? = nil
    
    return EditSessionView(
        navPath: $navPath,
        selectedTemplateSet: $selectedTemplateSet,
        selectedTemplateSession: $selectedTemplateSession
    )
    .environment(\.managedObjectContext, context)
}
