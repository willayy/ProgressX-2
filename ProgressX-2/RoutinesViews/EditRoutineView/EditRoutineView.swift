//
//  EditRoutineView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-19.
//

import SwiftUI
import CoreData

struct EditRoutineView: View {
    
    // To check for already taken routine names when trying to edit the routine.
    @FetchRequest(
        entity: Routine.entity(),
        sortDescriptors: []
    ) private var routines: FetchedResults<Routine>
    
    @Environment(\.managedObjectContext) private var viewContext
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
            
            BoldTitle(text: "Editing")
                .padding(.horizontal, 20)
                .onAppear(perform: {
                    viewModel.setViewStartValues(entity: selectedRoutine!)
                })
            
            Title2(text: "\(selectedRoutine!.timePeriodName!)")
                .padding(.bottom, 10)
            
            BoldSubHeadline(text: "Description:")
                .padding(.horizontal, 20)
            
            // Show red label if the routine has no description
            if selectedRoutine!.timePeriodDescription!.isEmpty {
                
                Text("No description.")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundStyle(.red)
                    .padding(.bottom, 20)
                
            } else {
                
                LightSubHeadline(text: selectedRoutine!.timePeriodDescription!)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 20)
                
            }
            
            // Expanding VSTACK containing an UI to edit the routine information
            ExpandingVStack(title: "Change routine information") {
                
                // MARK: Submission alert states
                if viewModel.showRoutineChangedAlert {
                    
                    SubmitAlert(message: "Successfully edited routine!", color: .green, showAlertState: $viewModel.showRoutineChangedAlert)
                        .padding(.top, 10)
                    
                } else if viewModel.showNoChangeAlert {
                    
                    SubmitAlert(message: "No change!", color: .blue, showAlertState: $viewModel.showNoChangeAlert)
                        .padding(.top, 10)
                    
                }
                
                // MARK: Edit routine name
                BoldSubHeadline(text: "Edit routine name")
                    .padding(.horizontal, 60)
                    .padding(.top, 10)
                
                InputField(
                    placeHolder: "Routine name",
                    text: $viewModel.editedRoutineName,
                    variant: TextIF()
                )
                .padding(.horizontal, 60)
                .padding(.bottom, 10)
                
                // MARK: Edit description
                BoldSubHeadline(text: "Edit routine description")
                
                HiddenLightSubHeadline(
                    title: "Why have a description?",
                    text: "Describing routines, or anything else for that matter, is optional in ProgressX. If you choose to use it, it should be used as a way to provide some more information about the routine in a way that can't be dont by it's title.",
                    alignment: .leading
                )
                .padding(.horizontal, 20)
                
                LargeInputField(
                    placeHolder: "Routine description",
                    text: $viewModel.editedRoutineDescription,
                    variant: TextIF(allowEmpty: true)
                )
                .frame(height: 150)
                .padding(.horizontal, 60)
                
                // MARK: Save changes in routine button
                Button {
                    
                    if GlobalInputFieldValidator.allFieldsValid() {
                        
                        viewModel.saveEdits(
                            entity: selectedRoutine!,
                            viewContext: viewContext
                        )
                        
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
            
            // MARK: List of all weeks in the routine
            BoldSubHeadline(text: "Current Weeks in this routine")
                .padding(.top, 20)
            
            HiddenLightSubHeadline(
                title: "What is a week?",
                text: "A week is meant as a set of training sessions that is supposed to be completed in the time span of a week."
            )
            .padding(.horizontal, 20)
            
            // The actual list of weeks
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
            }
            .padding(.horizontal, 20)
            
        }
            // MARK: Add new week button
            Button {
                
                viewModel.selectedTemplateCycle = selectedTemplateCycle!
                
                viewModel.saveEntry(viewContext: viewContext)
                
            } label: {
                
                Text("Add new Week")
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
    
    let fetchRequest: NSFetchRequest = Routine.fetchRequest()
    
    let routines = CoreDataAccess.fetch(context, fetchRequest: fetchRequest)
    
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
