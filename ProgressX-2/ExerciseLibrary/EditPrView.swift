//
//  EditPrView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-03.
//

import SwiftUI

struct EditPrView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var editingPr: PersonalRecord?
    @Binding var exercise: Exercise?
    @Binding var allPrs: [PersonalRecord]
    @State private var currDate: Date = Date()
    @State private var currLoad: String = ""
    @State private var currReps: String = ""
    @State private var currTime: String = ""
    @State private var newLoad: String = ""
    @State private var newReps: String = ""
    @State private var newTime: String = ""
    @State private var newDate: Date = Date()
    @State private var markNewLoadAsWrong: Bool = false
    @State private var markNewRepsAsWrong: Bool = false
    @State private var markNewTimeAsWrong: Bool = false
    @State private var prEditedAlert: Bool = false
    
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
    
    var body: some View {
        
        let weightUnit = DataFetching.getProfile(viewContext)!.isMetric ? "kg's" : "lbs"
        
        ScrollView {
            VStack(alignment: .center) {
                
                let typeString = { () -> String in
                    if editingPr! is OneRepMax {
                        return "1RM"
                    } else if editingPr! is MaxReps {
                        return "AMRAP"
                    } else if editingPr! is TimeMax {
                        return "Time-max"
                    }
                    return "NA"
                }()
                
                BoldTitle(text: "Editing PR for \(exercise!.exerciseName!)")
                
                if prEditedAlert {
                    showPrEditedAlert()
                }
                
                VStack(alignment: .leading) {
                    
                    (Text("Type: ")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                     + Text(typeString)
                        .fontWeight(.light)
                        .foregroundColor(.black))
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.5)
                    
                    (Text("Achieved on date: ")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                     + Text("\(DataUtility.formatDate(date: currDate))")
                        .fontWeight(.light)
                        .foregroundColor(.black))
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.5)
                    
                    (Text("Load: ")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                     + Text("\(currLoad) \(weightUnit)")
                        .fontWeight(.light)
                        .foregroundColor(.black))
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.5)
                
                    if exercise! is RepBasedExercise {
                        
                        let repString = { () -> String in
                            if editingPr! is OneRepMax {
                                return "1"
                            } else if editingPr! is MaxReps {
                                return String((editingPr! as! MaxReps).reps)
                            }
                            return "NA"
                        }()
                        
                        (Text("Reps: ")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                         + Text("\(repString)")
                            .fontWeight(.light)
                            .foregroundColor(.black))
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.5)
            
                    } else if exercise! is TimeBasedExercise {
                        
                        (Text("Time: ")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                         + Text("\(currTime) s")
                            .fontWeight(.light)
                            .foregroundColor(.black))
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.5)
                        
                    }
                }.padding(.bottom, 20)
                
                BoldSubHeadline(text: "Change date")
                
                DatePicker("", selection: $currDate, displayedComponents: .date)
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
                        
                        editingPr?.achievedOnDate = currDate
                        
                        // Handle all load since all PR's have load
                        newLoad = newLoad != "" ? newLoad : currLoad
                        editingPr!.load = Double(newLoad)!
                        currLoad = newLoad
                        newLoad = ""
                        
                        // Handle special case for MaxRep PR's
                        if let pr = editingPr as? MaxReps {
                            newReps = newReps != "" ? newReps : currReps
                            pr.reps = Int64(newReps)!
                            currReps = newReps
                            newReps = ""
                        }
                        
                        // Handle special case fpr TimeMax PR's
                        if let pr = editingPr as? TimeMax {
                            newTime = newTime != "" ? newTime : currTime
                            pr.time = Double(newTime)!
                            currTime = newTime
                            newTime = ""
                        }
                        
                        DataFetching.save(viewContext)
                        
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
        }.onAppear(perform: {
            currDate = editingPr!.achievedOnDate!
            currLoad = String(format:"%.2f",editingPr!.load)
            
            if let pr = editingPr as? MaxReps {
                currReps = String(pr.reps)
            }
            
            if editingPr is OneRepMax {
                currReps = "1"
            }
            
            if let pr = editingPr as? TimeMax {
                currTime = String(pr.time)
            }
        })
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    @State var exercise: Exercise? = DataFetching.getExercisesAsArray(context)
        .first(where:{$0.exerciseName == "testing exercise (reps)"}) as! RepBasedExercise
    @State var prs: [PersonalRecord] = (exercise as! RepBasedExercise).oneRepMaxPrs!.array as! [PersonalRecord]
    @State var pr: PersonalRecord? = prs.first
    
    return EditPrView(
        editingPr: $pr,
        exercise: $exercise,
        allPrs: $prs
    ).environment(\.managedObjectContext, context)
}
