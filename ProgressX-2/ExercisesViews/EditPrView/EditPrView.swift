//
//  EditPrView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-03.
//

import SwiftUI
import CoreData

struct EditPrView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var editingPr: PersonalRecord?
    @Binding var exercise: Exercise?
    @StateObject private var viewModel = EditPrViewModel()
    
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .center) {
                
                BoldTitle(text: "Editing PR for")
                    .padding(.horizontal, 20)
                    .onAppear(perform: {
                        viewModel.setViewStartValues(entity: editingPr!)
                    })
                
                Title2(text: "\(exercise!.exerciseName!)")
                
                // MARK: Submission alert states.
                if viewModel.prEditedAlert {
                    
                    SubmitAlert(
                        message: "Succesfully edited PR!",
                        color: .green,
                        showAlertState: $viewModel.prEditedAlert
                    )
                    .padding(.top, 10)
                    
                }
                
                if viewModel.noChangeAlert {
                    
                    SubmitAlert(
                        message: "No changes to PR",
                        color: .blue,
                        showAlertState: $viewModel.noChangeAlert
                    )
                    .padding(.top, 10)
                    
                }
                
                // MARK: Information about the PR.
                GroupBox {
                    
                    VStack(alignment: .leading) {
                        
                        (Text("Type: ")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                         + Text(editingPr!.typeString!)
                            .fontWeight(.light)
                            .foregroundColor(.black))
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.5)
                        
                        (Text("Achieved on date: ")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                         + Text("\(editingPr!.dateString!)")
                            .fontWeight(.light)
                            .foregroundColor(.black))
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.5)
                        
                        (Text("Load: ")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                         + Text("\(editingPr!.loadString!)")
                            .fontWeight(.light)
                            .foregroundColor(.black))
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.5)
                        
                        (Text("Quantity: ")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                         + Text("\(editingPr!.quantityString!)")
                            .fontWeight(.light)
                            .foregroundColor(.black))
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.5)
                        
                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 20)
                
                // MARK: Edit the date of the PR
                BoldSubHeadline(text: "Edit date")
                
                DatePicker("", selection: $viewModel.editedDate, displayedComponents: .date)
                    .datePickerStyle(DefaultDatePickerStyle())
                    .labelsHidden()
                    .padding(.bottom, 10)
                
                // MARK: Edit the load of the PR
                BoldSubHeadline(text: "Edit load")
                    .padding(.top, 10)
                
                InputField(
                    placeHolder: "Load",
                    text: $viewModel.editedWeightLoad,
                    variant: DecimalIF(min: 0, max: 10000)
                )
                .padding(.horizontal, 60)
                .padding(.bottom, 10)
                
                // MARK: Choose PR quantity
                // Declare variables for the PR's quantities inputField
                let prType = editingPr!.prType!
                
                let quantityFieldVariant: InputFieldVariant = viewModel.getInputFieldVariant(fromPrType: prType)
                
                let quantityFieldPlaceHolder: String = viewModel.getInputFieldPlaceholder(fromPrType: prType)
                
                InputField(
                    placeHolder: quantityFieldPlaceHolder,
                    text: $viewModel.editedQuantity,
                    variant: quantityFieldVariant
                )
                .padding(.horizontal, 60)
                .padding(.bottom, 10)
                
                // MARK: Save changes button
                Button(action: {
                    
                    if GlobalInputFieldValidator.allFieldsValid() {
                        
                        viewModel.saveEdits(entity: editingPr!, viewContext: viewContext)
                        
                    }
                    
                }) {
                    
                    Text("Save changes")
                        .frame(height: 40)
                        .foregroundColor(Color("buttonTextColor"))
                    
                    Image(systemName: "square.and.arrow.down")
                        .foregroundColor(Color("buttonTextColor"))
                    
                }
                .buttonStyle(BorderedProminentButtonStyle())
                .padding(.vertical, 20)
                
            }
            
        }
        
    }
    
}

#Preview {
    let context = PersistenceController.previewViewContext
    
    let fetchRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
    
    let exerciseResults: [Exercise] = CoreDataAccess.fetch(context, fetchRequest: fetchRequest)
    
    @State var exercise: Exercise? = exerciseResults.first
    
    @State var pr: PersonalRecord? = exercise?.personalRecords?.allObjects.first as? PersonalRecord
    
    return EditPrView(editingPr: $pr, exercise: $exercise)
    .environment(\.managedObjectContext, context)
}
