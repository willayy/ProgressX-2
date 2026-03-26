//
//  EditTemplateSetView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-03.
//

import SwiftUI
import CoreData

struct EditTemplateSetView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var navPath: [Int]
    
    @Binding var selectedTemplateSet: TemplateSet?
    
    @StateObject private var viewModel = EditTemplateSetViewModel()
    
    @State private var addBodyWeightButton: Bool = false
    
    var body: some View {
        
        ScrollView {
            
            BoldTitle(text: "Editing")
                .onAppear(perform: {
                    viewModel.setViewStartValues(entity: selectedTemplateSet!)
                })
            
            Title2(text: "\(selectedTemplateSet!.timePeriodName!)")
                .padding(.bottom, 10)
            
            // MARK: Submission alert state
            if viewModel.showSetChangedAlert {
                
                SubmitAlert(
                    message: "Successfully edited set!",
                    color: .green,
                    showAlertState: $viewModel.showSetChangedAlert
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
            
            // MARK: Set name
            BoldSubHeadline(text: "Edit set name")
            
            InputField(
                placeHolder: "Set name",
                text: $viewModel.editedSetName,
                variant: TextIF()
            )
            .padding(.horizontal, 60)
            .padding(.bottom, 5)
            
            // MARK: Set description
            BoldSubHeadline(text: "Edit set description")
            
            LargeInputField(
                placeHolder: "Set description",
                text: $viewModel.editedSetDesc,
                variant: TextIF(allowEmpty: false)
            )
            .frame(height: 150)
            .padding(.horizontal, 60)
            .padding(.bottom, 20)
            
            // MARK: Set thresholds
            BoldSubHeadline(text: "Edit or add thresholds for this set")
                .padding(.horizontal, 10)
            
            Button {
                navPath.append(8)
            } label: {
                Text("View thresholds")
                    .foregroundColor(Color("buttonTextColor"))
            }
            .buttonStyle(BorderedProminentButtonStyle())
            .padding(.bottom, 20)
            
            // MARK: Set position in session
            BoldSubHeadline(text: "Edit position of this set in its session")
            
            HiddenLightSubHeadline(
                title: "What does set position mean?",
                text: "The position of the set is meant as the sets position relative to other sets in this sesison. This is used to change the order you perform your sets when you do this session.",
                alignment: .leading
            )
            .padding(.horizontal, 20)
            
            IntSelectionList(
                selected: $viewModel.editedSetPositionIndex,
                selections: viewModel.positionIndexes(
                    selectedTemplateSet: selectedTemplateSet!
                )
            )
            .padding(.bottom, 20)
            .padding(.horizontal, 50)
            
            // MARK: Set exercise
            BoldSubHeadline(text: "Edit the exercise of the set")
            
            SetExerciseSelectionList(
                selectedExercise: $viewModel.selectedExercise,
                searchWord: $viewModel.searchWord
            )
            .padding(.bottom, 20)
            .padding(.horizontal, 50)
            
            BoldSubHeadline(text: "Edit the rest time of the set")
            
            InputField(
                placeHolder: "Rest time",
                text: $viewModel.editedRestTime,
                variant: DecimalIF(min: 0, max: 6000)
            )
            .padding(.horizontal, 60)
            .padding(.bottom, 20)
            
            BoldSubHeadline(text: "Edit the load type of the set")
            
            StringSelectionList(
                selected: $viewModel.editedLoadType,
                selections: viewModel.loadTypeSelections()
            )
            .onChange(of: viewModel.editedLoadType, initial: true) { oldValue, newValue in
                if newValue == "Numerical" {
                    withAnimation { addBodyWeightButton = true }
                } else {
                    withAnimation { addBodyWeightButton = false }
                }
            }
            .padding(.bottom, 20)
            .padding(.horizontal, 50)
            
            BoldSubHeadline(text: "Edit the quantity type of the set")
            
            StringSelectionList(
                selected: $viewModel.editedQuantityType,
                selections: viewModel.quantityTypeSelections()
            )
            .padding(.bottom, 20)
            .padding(.horizontal, 50)
            
            // MARK: Load of the template set
            BoldSubHeadline(text: "Edit the load of the set")
            
            HStack {
                
                InputField(
                    placeHolder: viewModel.loadPlaceholder(viewContext: viewContext),
                    text: $viewModel.editedSetLoad,
                    variant: DecimalIF(
                        min: 0,
                        max: 10000,
                        bwButton: true
                    )
                )
                
                if viewModel.loadPlaceholder(viewContext: viewContext) == "Percentage" {
                    
                    Text("%")
                    
                }
                
            }
            .padding(.horizontal, 60)
            
            // MARK: The quantity of the set
            BoldSubHeadline(text: "Edit the quantity of the set")
                .padding(.top, 5)
            
            let exerciseType = viewModel.selectedExercise?.exerciseType
            
            let variant = exerciseType == ExerciseType.Reps.rawValue ? IntegerIF(min: 0, max: 100000) : DecimalIF(min: 0, max: 100000)
            
            HStack {
                
                InputField(
                    placeHolder: viewModel.quantityPlaceholder(),
                    text: $viewModel.editedSetQuantity,
                    variant: variant
                )
                
                if viewModel.quantityPlaceholder() == "Percentage" {
                    Text("%")
                }
                
            }
            .padding(.horizontal, 60)
            
        }
        
        // MARK: Save changes
        Button {
            
            if GlobalInputFieldValidator.allFieldsValid() {
                
                viewModel.saveEdits(entity: selectedTemplateSet!, viewContext: viewContext)
                
            }
            
        } label: {
            
            Text("Save changes")
                .frame(height: 40)
                .foregroundColor(Color("buttonTextColor"))
            
            Image(systemName: "square.and.arrow.down")
                .foregroundColor(Color("buttonTextColor"))
            
        }
        .buttonStyle(BorderedProminentButtonStyle())
        .padding(.top, 20)
        .padding(.bottom, 10)
                            
    }
    
}

#Preview {

    let context = PersistenceController.previewViewContext
    let fetchReqeust: NSFetchRequest = TemplateSet.fetchRequest()
    let templateSets = CoreDataAccess.fetch(context, fetchRequest: fetchReqeust)
    
    @State var selectedTemplateSet: TemplateSet? = templateSets.first
    @State var navPath: [Int] = [Int]()

    return EditTemplateSetView(
        navPath: $navPath,
        selectedTemplateSet: $selectedTemplateSet
    )
    .environment(\.managedObjectContext, context)
}
