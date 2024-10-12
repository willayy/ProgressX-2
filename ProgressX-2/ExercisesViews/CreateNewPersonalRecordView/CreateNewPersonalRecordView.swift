//
//  CreateNewPersonalRecord.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-17.
//

import SwiftUI
import CoreData

struct CreateNewPersonalRecord: View {
    
    // Fetch bodyEntres to get current weight
    @FetchRequest(
        entity: BodyEntry.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \BodyEntry.achievedOnDate, ascending: false)]
    ) private var bodyEntries: FetchedResults<BodyEntry>
    
    @Binding var prType: String? // The selection of the segmented picker
    
    @Binding var navPath: [Int]
    
    @Binding var selectedExercise: Exercise? // Exercise for the PR
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @StateObject private var viewModel = CreateNewPersonalRecordViewModel()
    
    var body: some View {
        
        ScrollView {
            
            VStack {
                
                BoldTitle(
                    text: "Create a new PR for"
                )
                .padding(.horizontal, 20)
                
                Title2(text: "\(selectedExercise!.exerciseName!)")
                .padding(.horizontal, 20)
                
                HiddenLightSubHeadline(
                    title: "What are PR's?",
                    text: "A PR (personal record) is a dated record of how you performed on an exercise. For rep based exercises the available PR's are AMRAP (As many reps as possible) and 1RM (one rep max). For time based exercise there is only Time-max PR's which is like an AMRAP PR but instead of counting the reps you did it counts the time you did."
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
                // MARK: Choose PR date
                BoldSubHeadline(text: "Choose a date for the PR")
                
                DatePicker("", selection: $viewModel.prDate, displayedComponents: .date)
                    .datePickerStyle(DefaultDatePickerStyle())
                    .labelsHidden()
                    .padding(.bottom, 20)
                
                // MARK: Choose PR load
                BoldSubHeadline(text: "Choose a load for the PR")
                
                InputField(
                    placeHolder: "Load",
                    text: $viewModel.prLoad,
                    variant: DecimalIF(min: 0, max: 10000)
                )
                .padding(.horizontal, 60)
                .padding(.bottom, 10)
                .onAppear(perform: { viewModel.setPrQuantity(basedOn: prType!) })
                
                // MARK: Choose PR quantity
                // Declare variables for the PR's quantities inputField
                let quantityFieldVariant: InputFieldVariant = viewModel.getInputFieldVariant(fromPrType: prType!)
                
                let quantityFieldPlaceHolder: String = viewModel.getInputFieldPlaceholder(fromPrType: prType!)
                
                InputField(
                    placeHolder: quantityFieldPlaceHolder,
                    text: $viewModel.prQuantity,
                    variant: quantityFieldVariant
                )
                .padding(.horizontal, 60)
                
                // MARK: Handle the creation of a PR
                Button(action: {
                    
                    if GlobalInputFieldValidator.allFieldsValid() {
                        
                        viewModel.selectedExercise = selectedExercise!
                        
                        viewModel.selectedPrType = prType!
                        
                        viewModel.saveEntry(viewContext: viewContext)
                        
                        navPath.removeLast()
                        
                    }
                    
                }) {
                    
                    Text("Create new PR")
                        .frame(height: 40)
                        .foregroundColor(Color("buttonTextColor"))
                    
                    Image(systemName: "plus")
                        .foregroundColor(Color("buttonTextColor"))
                    
                }
                .padding(.vertical, 20)
                .buttonStyle(BorderedProminentButtonStyle())
                
            }
            .frame(maxWidth: .infinity)
            
        }
        
    }
    
}

#Preview {
    let context = PersistenceController.previewViewContext
    
    let fetchRequestRepBasedExercise: NSFetchRequest<Exercise> = Exercise.fetchRequest()
    fetchRequestRepBasedExercise.predicate = NSPredicate(format: "exerciseType == %@", "reps")
    
    let exerciseResults: [Exercise] = CoreDataAccess.fetch(context, fetchRequest: fetchRequestRepBasedExercise)
    
    @State var exercise: Exercise? = exerciseResults.first
    
    @State var prType: String? = "onerepmax"
    
    @State var navPath: [Int] = [Int]()
    
    return CreateNewPersonalRecord(
        prType: $prType,
        navPath: $navPath,
        selectedExercise: $exercise
    )
}
