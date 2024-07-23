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
                        viewModel.showChangeInfo.toggle()
                    }
                } label: {
                    BoldSubHeadline(text: "Change week informaton")
                        .frame(width: 240)
                }
                .buttonStyle(BorderedButtonStyle())
                
                // Expandable hidden view that has functionality for changing name and description.
                if viewModel.showChangeInfo {
                    VStack {
                        if viewModel.showWeekChangedAlert {
                            SubmitAlert(
                                message: "Successfully edited week!",
                                color: .green,
                                showAlertState: $viewModel.showWeekChangedAlert
                            )
                        } else if viewModel.showNoChangeAlert {
                            SubmitAlert(
                                message: "No change!",
                                color: .blue,
                                showAlertState: $viewModel.showNoChangeAlert
                            )
                        }
                        
                        InputTextField(
                            placeHolder: "New week name",
                            text: $viewModel.editedWeekName, 
                            maxChars: 25,
                            markAsWrong: $viewModel.editedWeekIsInvalid,
                            width: 0.6,
                            errorMessage: $viewModel.editedWeekNameIsInvalidMsg
                        )
                        
                        InputTextField(
                            placeHolder: "New week description",
                            text: $viewModel.editedWeekDescription, 
                            maxChars: 25,
                            markAsWrong: $viewModel.editedWeekDescIsInvalid,
                            width: 0.6,
                            errorMessage: $viewModel.editedWeekDescIsInvalidMsg
                        )
                        
                        LightSubHeadline(text: "Change the weeks position in the routine")
                            .padding(.top, 10)
                        
                        IntSelectionList(
                            selected: $viewModel.editedPositionIndex,
                            selections: viewModel.positionIndexes(selectedTemplateWeek: selectedTemplateWeek)
                        )
                        
                        Button {
                            if validateInput() {
                                viewModel.saveTemplateWeekChanges(viewContext: viewContext, selectedTemplateWeek: selectedTemplateWeek)
                            }
                        } label: {
                            Text("Save change")
                                .frame(height: 40)
                                .foregroundColor(Color("buttonTextColor"))
                            Image(systemName: "square.and.arrow.down")
                                .foregroundColor(Color("buttonTextColor"))
                        }
                        .buttonStyle(BorderedProminentButtonStyle())
                        .padding(.top, 10)
                        
                    }
                }
                    
                BoldSubHeadline(text: "Current sessions in this week")
                    .padding(.top, 20)
                
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
                    .environment(\.managedObjectContext, viewContext)
                }
                .padding(.horizontal, 20)
                
                Button {
                    viewModel.addSession(
                        viewContext: viewContext,
                        selectedTemplateWeek: selectedTemplateWeek
                    )
                } label: {
                    Text("Add new Session")
                        .frame(height: 40)
                        .foregroundColor(Color("buttonTextColor"))
                    Image(systemName: "plus")
                        .foregroundColor(Color("buttonTextColor"))
                }
                .buttonStyle(BorderedProminentButtonStyle())
                .padding(.top, 20)
                .padding(.bottom, 10)
            
            }
        }.onAppear(perform: {
            viewModel.setViewStartValues(week: selectedTemplateWeek!)
        })
    }
    
    private func validateInput() -> Bool {
        var valid: Int = 0
        
        let weekNameValidator = StringFieldValidator()
        let weekDescValidator = StringFieldValidator(emptyAllowed: true)
        
        valid += weekNameValidator.valideField(
            inputVar: viewModel.editedWeekName,
            errorMessage: $viewModel.editedWeekNameIsInvalidMsg,
            fieldInvalid: $viewModel.editedWeekIsInvalid
        )
        
        valid += weekDescValidator.valideField(
            inputVar: viewModel.editedWeekDescription,
            errorMessage: $viewModel.editedWeekDescIsInvalidMsg,
            fieldInvalid: $viewModel.editedWeekDescIsInvalid
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
    
    return EditTemplateWeekView(
        navPath: $navPath,
        selectedTemplateWeek: $selectedTemplateWeek, 
        selectedTemplateSession: $selectedTemplateSession
    )
    .environment(\.managedObjectContext, context)
}
