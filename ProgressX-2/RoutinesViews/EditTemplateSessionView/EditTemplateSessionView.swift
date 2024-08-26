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
                
                BoldTitle(text: "Editing")
                    .padding(.horizontal, 20)
                    .onAppear(perform: {
                        viewModel.setViewStartValues(
                            entity: selectedTemplateSession!
                        )
                    })
                
                Title2(text: "\(selectedTemplateSession!.timePeriodName!)")
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
                
                // Expandable hidden view that has functionality for changing name and description.
                
                ExpandingVStack(title: "Change session info") {
                    
                    if viewModel.showSessionChangedAlert {
                        SubmitAlert(message: "Successfully edited session!", color: .green, showAlertState: $viewModel.showSessionChangedAlert)
                            .padding(.top, 10)
                    } else if viewModel.showNoChangeAlert {
                        SubmitAlert(message: "No change!", color: .blue, showAlertState: $viewModel.showNoChangeAlert)
                            .padding(.top, 10)
                    }
                    
                    BoldSubHeadline(text: "Edit session name")
                        .padding(.top, 10)
                    
                    InputTextField(
                        placeHolder: "Session name",
                        text: $viewModel.editedSessionName,
                        markAsWrong: $viewModel.editedSessionIsInvalid,
                        errorMessage: $viewModel.editedSessionNameIsInvalidMsg,
                        maxChars: 25
                    )
                    .padding(.horizontal, 60)
                    
                    BoldSubHeadline(text: "Edit session description")
                        .padding(.top, 10)
                    
                    HiddenLightSubHeadline(
                        title: "Why have a description?",
                        text: "Describing sesisons, or anything else for that matter, is optional in ProgressX. If you choose to use it, it should be used as a way to provide some more information about the session in a way that can't be dont by it's title.",
                        alignment: .leading
                    )
                    .padding(.horizontal, 20)
                    
                    inputLongTextField(
                        placeHolder: "Session description",
                        text: $viewModel.editedSessionDescription,
                        markAsWrong: $viewModel.editedSessionDescIsInvalid,
                        errorMessage: $viewModel.editedSessionDescIsInvalidMsg,
                        maxChars: 200
                    )
                    .frame(height: 150)
                    .padding(.horizontal, 60)
                    
                    LightSubHeadline(text: "Change the sessions position in the week")
                        .padding(.top, 10)
                    
                    IntSelectionList(
                        selected: $viewModel.editedPositionIndex,
                        selections: viewModel.positionIndexes(
                            selectedTemplateSession: selectedTemplateSession!
                        )
                    )
                    .backgroundStyle(.white)
                    .padding(.horizontal, 40)
                    
                    Button {
                        if validateInput() {
                            viewModel.saveEdits(entity: selectedTemplateSession!, viewContext: viewContext)
                        }
                    } label: {
                        Text("Save change")
                            .frame(height: 40)
                            .foregroundColor(Color("buttonTextColor"))
                        Image(systemName: "square.and.arrow.down")
                            .foregroundColor(Color("buttonTextColor"))
                    }
                    .buttonStyle(BorderedProminentButtonStyle())
                    .padding(.vertical, 10)
                    
                }
                .padding(.horizontal, 20)
                    
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
                .padding(.horizontal, 20)
                
                Button {
                    navPath.append(7)
                } label: {
                    Text("Add new set")
                        .frame(height: 40)
                        .foregroundColor(Color("buttonTextColor"))
                    Image(systemName: "plus")
                        .foregroundColor(Color("buttonTextColor"))
                }
                .buttonStyle(BorderedProminentButtonStyle())
                .padding(.top, 20)
                .padding(.bottom, 10)
            
            }
        }
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
    let context = PersistenceController.previewViewContext
    let fetchRequest: NSFetchRequest = TemplateSession.fetchRequest()
    let sessions = CoreDataAccess.fetch(context, fetchRequest: fetchRequest)
    
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
