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
    // Fetch the Profile to se if its metric or not
    @FetchRequest(
        entity: Profile.entity(),
        sortDescriptors: []
    ) private var profileResults: FetchedResults<Profile>
    
    @Binding var editingPr: PersonalRecord?
    @Binding var exercise: Exercise?
    @State private var newLoad: String = ""
    @State private var newReps: String = ""
    @State private var newTime: String = ""
    @State private var newDate: Date = Date()
    @State private var markNewLoadAsWrong: Bool = false
    @State private var markNewRepsAsWrong: Bool = false
    @State private var markNewTimeAsWrong: Bool = false
    @State private var prEditedAlert: Bool = false
    
    var body: some View {
        
        let weightUnit = profileResults.first!.isMetric ? "kg's" : "lbs"
        
        ScrollView {
            VStack(alignment: .center) {
                
                BoldTitle(text: "Editing PR for \(exercise!.exerciseName!)")
                
                if prEditedAlert {
                    showPrEditedAlert()
                }
                
                VStack(alignment: .leading) {
                    
                    (Text("Type: ")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                     + Text(editingPr!.typeString())
                        .fontWeight(.light)
                        .foregroundColor(.black))
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.5)
                    
                    (Text("Achieved on date: ")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                     + Text("\(editingPr!.dateString()!)")
                        .fontWeight(.light)
                        .foregroundColor(.black))
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.5)
                    
                    (Text("Load: ")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                     + Text("\(editingPr!.loadString()) \(weightUnit)")
                        .fontWeight(.light)
                        .foregroundColor(.black))
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.5)
                    
                    (Text("Quantity: ")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                     + Text("\(editingPr!.quantityString()) \(editingPr!.quantityUnitString())")
                        .fontWeight(.light)
                        .foregroundColor(.black))
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.5)
                
                }.padding(.bottom, 20)
                
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
                    numberText: $newLoad,
                    markAsWrong: $markNewLoadAsWrong,
                    width: 0.7,
                    errorMessage: "Invalid input"
                )
                
                if editingPr! is MaxReps {
                    InputIntegerNumberField(
                        placeHolder: "New reps...",
                        numberText: $newReps,
                        markAsWrong: $markNewRepsAsWrong,
                        width: 0.7,
                        errorMessage: "Invalid input"
                    )
                } else if editingPr! is TimeMax {
                    InputDecimalNumberField(
                        placeHolder: "new time",
                        numberText: $newTime,
                        markAsWrong: $markNewTimeAsWrong,
                        width: 0.7,
                        errorMessage: "Invalid input"
                    )
                }
                
                Button(action: {
                    if validateInput() {
                        
                        editingPr!.achievedOnDate = newDate
                        
                        // Handle all load since all PR's have load
                        editingPr!.weightLoad = newLoad != "" ? Double(newLoad)! : editingPr!.weightLoad
                        newLoad = ""
                        
                        // Handle special case for MaxRep PR's
                        if editingPr is  MaxReps {
                            editingPr!.prQuantity = Double(newReps)!
                            newReps = ""
                        }
                        
                        // Handle special case fpr TimeMax PR's
                        if editingPr is TimeMax {
                            editingPr!.prQuantity = Double(newTime)!
                            newTime = ""
                        }
                        
                        PersistenceController.save(viewContext)
                        
                        withAnimation {
                            prEditedAlert = true
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
    
    private func showPrEditedAlert() -> some View {
        Text("Succesfully edited PR")
            .fontWeight(.light)
            .foregroundStyle(.green)
            .padding(.bottom, 10)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    withAnimation {
                        prEditedAlert = false
                    }
                }
            }
    }
    
    private func validateInput() -> Bool {
        
        var valid: Bool = true
        
        if newLoad != "" {
            if let _ = Double(newLoad) {} else {
                valid = false
                withAnimation {
                    markNewLoadAsWrong = true
                }
            }
        }
        
        if editingPr! is MaxReps && newReps != "" {
            if let _ = Int(newReps) {} else {
                valid = false
                withAnimation {
                    markNewRepsAsWrong = true
                }
            }
        }
        
        if editingPr! is TimeMax && newTime != "" {
            if let _ = Double(newTime) {} else {
                valid = false
                withAnimation {
                    markNewTimeAsWrong = true
                }
            }
        }
        
        return valid
    }
    
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    
    let fetchRequestRepBasedExercise: NSFetchRequest<RepBasedExercise> = RepBasedExercise.fetchRequest()
    
    let exerciseResults: [RepBasedExercise] = PersistenceController.fetch(context, fetchRequest: fetchRequestRepBasedExercise)
    
    @State var exercise: Exercise? = exerciseResults.first
    
    @State var pr: PersonalRecord? = exercise?.personalRecords?.array.first as? PersonalRecord 
    
    return EditPrView(editingPr: $pr, exercise: $exercise)
    .environment(\.managedObjectContext, context)
}
