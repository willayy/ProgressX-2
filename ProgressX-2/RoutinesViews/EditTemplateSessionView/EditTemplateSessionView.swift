//
//  EditSessionView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-01.
//

import SwiftUI
import CoreData

struct EditTemplateSessionView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = EditTemplateSessionViewModel()
    @Binding var navPath: [Int]
    @Binding var selectedTemplateSet: TemplateSet?
    @Binding var selectedTemplateSession: TemplateSession?
    @Binding var selectedThreshold: SetThreshold?
    
    var body: some View {

        // Get the templateSets for this session.
        @FetchRequest(
            entity: TemplateSet.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \TemplateSet.positionIndex, ascending: true)],
            predicate: NSPredicate(format: "templateSession == %@", selectedTemplateSession!)
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
                        viewModel.showChangeInfo.toggle()
                    }
                } label: {
                    BoldSubHeadline(text: "Change session informaton")
                        .frame(width: 240)
                }
                .buttonStyle(BorderedButtonStyle())
                
                // Expandable hidden view that has functionality for changing name and description.
                if viewModel.showChangeInfo {
                    VStack {
                        if viewModel.showSessionChangedAlert {
                            SubmitAlert(message: "Successfully edited session!", color: .green, showAlertState: $viewModel.showSessionChangedAlert)
                        } else if viewModel.showNoChangeAlert {
                            SubmitAlert(message: "No change!", color: .blue, showAlertState: $viewModel.showNoChangeAlert)
                        }
                        
                        InputTextField(
                            placeHolder: "New session name",
                            text: $viewModel.editedSessionName,
                            maxChars: 25,
                            markAsWrong: $viewModel.editedSessionIsInvalid,
                            width: 0.6,
                            errorMessage: $viewModel.editedSessionNameIsInvalidMsg
                        )
                        .padding(.top, 10)
                        
                        InputTextField(
                            placeHolder: "New session description",
                            text: $viewModel.editedSessionDescription,
                            maxChars: 200,
                            markAsWrong: $viewModel.editedSessionDescIsInvalid,
                            width: 0.6,
                            errorMessage: $viewModel.editedSessionDescIsInvalidMsg
                        )
                        
                        LightSubHeadline(text: "Change the sessions position in the week")
                            .padding(.top, 10)
                        
                        IntSelectionList(
                            selected: $viewModel.editedPositionIndex,
                            selections: viewModel.positionIndexes(
                                selectedTemplateSession: selectedTemplateSession
                            )
                        )
                        
                        Button {
                            if validateInput() {
                                viewModel.saveTemplateSessionChanges(
                                    viewContext: viewContext,
                                    selectedTemplateSession: selectedTemplateSession
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
                    
                BoldSubHeadline(text: "Current sets in this session")
                    .padding(.top, 20)
                
                // MARK: List of sets
                BasicList(
                    height: 400,
                    containerName: "this session",
                    elementName: "sets",
                    data: _templateSets
                ) { set in
                    TemplateSetListItem(
                        navPath: $navPath,
                        selectedTemplateSet: $selectedTemplateSet,
                        selectedThreshold: $selectedThreshold,
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
        .onAppear(perform: {
            viewModel.setViewStartValues(
                selectedTemplateSession: selectedTemplateSession
            )
        })
    }
    
    private func validateInput() -> Bool {
        var valid: Int = 0
        
        let sessionNameValidator = StringFieldValidator()
        let sessionDescValidator = StringFieldValidator(emptyAllowed: true)
        
        valid += sessionNameValidator.valideField(
            inputVar: viewModel.editedSessionName,
            errorMessage: $viewModel.editedSessionNameIsInvalidMsg,
            fieldInvalid: $viewModel.editedSessionIsInvalid
        )
        
        valid += sessionDescValidator.valideField(
            inputVar: viewModel.editedSessionDescription,
            errorMessage: $viewModel.editedSessionDescIsInvalidMsg,
            fieldInvalid: $viewModel.editedSessionDescIsInvalid
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
    @State var selectedThreshold: SetThreshold? = nil
    
    return EditTemplateSessionView(
        navPath: $navPath,
        selectedTemplateSet: $selectedTemplateSet,
        selectedTemplateSession: $selectedTemplateSession,
        selectedThreshold: $selectedThreshold
    )
    .environment(\.managedObjectContext, context)
}
