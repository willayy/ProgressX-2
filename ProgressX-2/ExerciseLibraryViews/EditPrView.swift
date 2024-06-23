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

    // Input field vars
    @State private var newDate: Date = Date()
    @State private var newQuantity: String = ""
    @State private var newWeightLoad: String = ""
    @State private var newQuantityInvalid: Bool = false
    @State private var newWeightLoadInvalid: Bool = false
    @State private var newQuantityInvalidMsg: String = ""
    @State private var newWeightLoadInvalidMsg: String = ""
    
    // Alert vars
    @State private var prEditedAlert: Bool = false
    @State private var noChangeAlert: Bool = false
    
    var body: some View {
        
        let weightUnit = PersistenceController.getWeightUnit(viewContext)!
        
        ScrollView {
            VStack(alignment: .center) {
                
                BoldTitle(text: "Editing PR for: \(exercise!.exerciseName!)")
                
                if prEditedAlert {
                    SubmitAlert(message: "Succesfully edited PR!", color: .green, showAlertState: $prEditedAlert)
                }
                
                if noChangeAlert {
                    SubmitAlert(message: "No changes to PR", color: .blue, showAlertState: $noChangeAlert)
                }
                
                VStack(alignment: .leading) {
                    
                    (Text("Type: ")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                     + Text(editingPr!.typeString)
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
                     + Text("\(editingPr!.loadString) \(weightUnit)")
                        .fontWeight(.light)
                        .foregroundColor(.black))
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.5)
                    
                    (Text("Quantity: ")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                     + Text("\(editingPr!.quantityString) \(editingPr!.quantityUnitString)")
                        .fontWeight(.light)
                        .foregroundColor(.black))
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.5)
                
                }
                .padding(.bottom, 20)
                
                BoldSubHeadline(text: "Change date")
                
                DatePicker("", selection: $newDate, displayedComponents: .date)
                    .datePickerStyle(DefaultDatePickerStyle())
                    .labelsHidden()
                    .padding(.bottom, 10)
                    .onAppear(perform: {
                        newDate = editingPr!.achievedOnDate!
                    })
                
                InputDecimalNumberField(
                    placeHolder: "New load...",
                    numberText: $newWeightLoad,
                    markAsWrong: $newWeightLoadInvalid,
                    width: 0.7,
                    errorMessage: $newWeightLoadInvalidMsg
                )
                .padding(.top, 10)
                .padding(.bottom, 10)
                
                if editingPr!.prType == "maxreps" {
                    InputIntegerNumberField(
                        placeHolder: "New reps...",
                        numberText: $newQuantity,
                        markAsWrong: $newQuantityInvalid,
                        width: 0.7,
                        errorMessage: $newQuantityInvalidMsg
                    )
                    .padding(.bottom, 10)
                } else if editingPr!.prType == "timemax" {
                    InputDecimalNumberField(
                        placeHolder: "New time...",
                        numberText: $newQuantity,
                        markAsWrong: $newQuantityInvalid,
                        width: 0.7,
                        errorMessage: $newQuantityInvalidMsg
                    )
                    .padding(.bottom, 10)
                }
                
                Button(action: {
                    if validateInput() {
                        
                        editingPr!.weightLoad = newWeightLoad.isEmpty ? editingPr!.weightLoad : Double(newWeightLoad)!
                        editingPr!.prQuantity = newQuantity.isEmpty ? editingPr!.prQuantity : Double(newQuantity)!
                        
                        PersistenceController.save(viewContext)
                        
                        if newWeightLoad.isEmpty && newQuantity.isEmpty && newDate == editingPr!.achievedOnDate {
                            editingPr!.achievedOnDate = newDate
                            withAnimation(.easeOut) {
                                noChangeAlert = true
                                newWeightLoad = ""
                                newQuantity = ""
                            }
                        } else {
                            editingPr!.achievedOnDate = newDate
                            withAnimation(.easeOut) {
                                prEditedAlert = true
                                newWeightLoad = ""
                                newQuantity = ""
                            }
                        }
                    }
                }) {
                    Text("Save changes")
                        .frame(height: 40)
                    Image(systemName: "square.and.arrow.down")
                }
                .buttonStyle(BorderedProminentButtonStyle())
                .padding(.top, 10)
                
            }
        }
    }
    
    private func validateInput() -> Bool {
        var valid: Int = 0
        let loadFieldValidator = DoubleFieldValidator(emptyAllowed: true)
        let quantityFieldValidator: InputFieldValidator = {
            return (editingPr!.prType == "timemax" ? DoubleFieldValidator(emptyAllowed: true) : IntFieldValidator(emptyAllowed: true))
        }()
        
        valid += loadFieldValidator.valideField(inputVar: newWeightLoad, errorMessage: $newWeightLoadInvalidMsg, fieldInvalid: $newWeightLoadInvalid)
        valid += quantityFieldValidator.valideField(inputVar: newQuantity, errorMessage: $newQuantityInvalidMsg, fieldInvalid: $newQuantityInvalid)
        
        return valid == 0
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    
    let fetchRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
    
    let exerciseResults: [Exercise] = PersistenceController.fetch(context, fetchRequest: fetchRequest)
    
    @State var exercise: Exercise? = exerciseResults.first
    
    @State var pr: PersonalRecord? = exercise?.personalRecords?.allObjects.first as? PersonalRecord
    
    return EditPrView(editingPr: $pr, exercise: $exercise)
    .environment(\.managedObjectContext, context)
}
