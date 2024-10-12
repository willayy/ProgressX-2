//
//  EditCycleView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-23.
//

import SwiftUI
import CoreData

struct EditTemplateWeekView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var navPath: [Int]
    
    @Binding var selectedTemplateWeek: TemplateWeek?
    
    @Binding var selectedTemplateSession: TemplateSession?
    
    @StateObject private var viewModel = EditTemplateWeekViewModel()
    
    var body: some View {

        // Get the templateSessions for this week.
        @FetchRequest(
            entity: TemplateSession.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \TemplateSession.positionIndex, ascending: true)],
            predicate: NSPredicate(format: "templateWeek == %@", selectedTemplateWeek!)
        ) var templateSessions: FetchedResults<TemplateSession>
        
        ScrollView {
                
                BoldTitle(text: "Editing")
                    .padding(.horizontal, 20)
                    .onAppear(perform: {
                        viewModel.setViewStartValues(entity: selectedTemplateWeek!)
                    })
                
                Title2(text: "\(selectedTemplateWeek!.timePeriodName!)")
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
                
                // Expandable hidden view that has functionality for changing name and description.
                ExpandingVStack(title: "Change week information") {
                    
                    // MARK: Submission Alert state.
                    if viewModel.showWeekChangedAlert {
                        
                        SubmitAlert(
                            message: "Successfully edited week!",
                            color: .green,
                            showAlertState: $viewModel.showWeekChangedAlert
                        )
                        .padding(.top, 10)
                        
                    } else if viewModel.showNoChangeAlert {
                        
                        SubmitAlert(
                            message: "No change!",
                            color: .blue,
                            showAlertState: $viewModel.showNoChangeAlert
                        )
                        .padding(.top, 10)
                        
                    }
                    
                    BoldSubHeadline(text: "Edit week name")
                    
                    InputField(
                        placeHolder: "Week name",
                        text: $viewModel.editedWeekName,
                        variant: TextIF()
                    )
                    .padding(.horizontal, 60)
                    
                    BoldSubHeadline(text: "Edit week description")
                        .padding(.top, 10)
                    
                    HiddenLightSubHeadline(
                        title: "Why have a description?",
                        text: "Describing weeks, or anything else for that matter, is optional in ProgressX. If you choose to use it, it should be used as a way to provide some more information about the week in a way that can't be dont by it's title.",
                        alignment: .leading
                    )
                    .padding(.horizontal, 20)
                    
                    LargeInputField(
                        placeHolder: "New week description",
                        text: $viewModel.editedWeekDescription,
                        variant: TextIF(allowEmpty: true)
                    )
                    .frame(height: 150)
                    .padding(.horizontal, 60)
                    
                    LightSubHeadline(text: "Change the weeks position in the routine")
                        .padding(.top, 10)
                    
                    IntSelectionList(
                        selected: $viewModel.editedPositionIndex,
                        selections: viewModel.positionIndexes(selectedTemplateWeek: selectedTemplateWeek!)
                    )
                    .backgroundStyle(.white)
                    .padding(.horizontal, 40)
                    
                    // MARK: Save changes button.
                    Button {
                        
                        if GlobalInputFieldValidator.allFieldsValid() {
                            
                            viewModel.saveEdits(entity: selectedTemplateWeek!, viewContext: viewContext)
                            
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
                
                BoldSubHeadline(text: "Current sessions in this week")
                    .padding(.top, 20)
                
                HiddenLightSubHeadline(
                    title: "What is a session?",
                    text: "A training session is a single gym session and is meant to be completed in 1-3 hours.",
                    alignment: .leading
                )
                .padding(.horizontal, 20)
                
                // MARK: Sessions in the week.
                BasicList(
                    height: 400,
                    containerName: "this week",
                    elementName: "session",
                    data: _templateSessions
                ) { session in
                    TemplateSessionListItem(
                        navPath: $navPath,
                        selectedTemplateSession: $selectedTemplateSession,
                        session: session
                    )
                }
                .padding(.horizontal, 20)
                
            }
                
                // MARK: Add new session.
                Button {
                    
                    viewModel.selectedTemplateWeek = selectedTemplateWeek!
                    
                    viewModel.saveEntry(viewContext: viewContext)
                    
                } label: {
                    
                    Text("Add new Session")
                        .frame(height: 40)
                        .foregroundColor(Color("buttonTextColor"))
                    
                    Image(systemName: "plus")
                        .foregroundColor(Color("buttonTextColor"))
                    
                }
                .buttonStyle(BorderedProminentButtonStyle())
                .padding(.vertical, 20)
            
        }
    
}

#Preview {
    
    let context = PersistenceController.previewViewContext
    
    let fetchRequest: NSFetchRequest = TemplateWeek.fetchRequest()
    
    let weeks = CoreDataAccess.fetch(context, fetchRequest: fetchRequest)
    
    let week = weeks.first!
    
    @State var navPath: [Int] = [Int]()
    
    @State var selectedTemplateWeek: TemplateWeek? = week
    
    @State var selectedTemplateSession: TemplateSession? = nil
    
    return EditTemplateWeekView(
        navPath: $navPath,
        selectedTemplateWeek: $selectedTemplateWeek, 
        selectedTemplateSession: $selectedTemplateSession
    )
    .environment(\.managedObjectContext, context)
    
}
