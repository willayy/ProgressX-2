//
//  PopupFeedbackView.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-07-29.
//
import Foundation
import SwiftUI
import CoreData

struct PopupFeedbackView: View {
    
    @StateObject private var viewModel = PopupFeedbackViewModel()
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var currentTrainingSet: TrainingSet?
    @Binding var presentPopup: Bool
    
    var body: some View {
        VStack{
            if !viewModel.showWindow {
                
                if ((currentTrainingSet?.exercise?.exerciseType = "reps") != nil) {
                    BoldTitle(text: "Did you complete all your reps?")
                } else if ((currentTrainingSet?.exercise?.exerciseType = "time") != nil) {
                    BoldTitle(text: "Did you complete the exercise witin the given timeframe")
                }
                
                HStack{
                    Button(action:{
                        viewModel.showWindow.toggle()
                        viewModel.changeText(text: "How many reps did you do?")
                    }) {
                        Text("NO")
                            .bold()
                            .frame(width: 120, height: 70)
                    }
                    .tint(.red)
                    .buttonStyle(BorderedProminentButtonStyle())
                    .padding(.leading, 40)
                    
                    Spacer()
                    
                    Button(action:{
                        viewModel.setFullyCompleted(currentTrainingSet: currentTrainingSet!)
                        viewModel.saveEdits(entity: currentTrainingSet!, viewContext: viewContext)
                        self.presentPopup.toggle()
                    }) {
                        Text("YES")
                            .bold()
                            .frame(width: 120, height: 70)
                    }
                    .tint(.green)
                    .buttonStyle(BorderedProminentButtonStyle())
                    .padding(.trailing, 40)
                    
                }
                .padding(.top)
                
            } else {
                BoldTitle(text: viewModel.text)
                    .padding(.horizontal, 20)
                
                LightSubHeadline(text: "Out of a total \(currentTrainingSet!.quantityTodoString!)")
                    .padding(.vertical, 5)
                
                #warning("TODO: Fix this so its reps and time")
                IntegerTextField(
                    placeHolder: "Enter how many reps you did!",
                    numberText: $viewModel.editedSetQuantity,
                    markAsWrong: $viewModel.editedSetQuantityIsInvalid,
                    errorMessage: $viewModel.editedSetQuantityIsInvalidMsg,
                    allowNegatives: false
                )
                .padding(.horizontal, 60)
                .padding(.top, 5)
                
                Button(action:{
                    let quantityDone = Double(viewModel.editedSetQuantity)!
                    viewModel.setPartiallyCompleted(currentTrainingSet: currentTrainingSet!, quantityDone: quantityDone)
                    viewModel.saveEdits(entity: currentTrainingSet!, viewContext: viewContext)
                    self.presentPopup.toggle()
                }) {
                    Text("Done")
                        .bold()
                        .frame(width: 120, height: 40)
                }
                .buttonStyle(BorderedProminentButtonStyle())
                .padding(.top)
            }
        }
        .onAppear(perform: {
            viewModel.setViewStartValues(entity: currentTrainingSet!)
        })
    }
}



#Preview{
    let context = PersistenceController.preview.container.viewContext
    let fetchRequest: NSFetchRequest = TrainingSet.fetchRequest()
    let trainingSets = PersistenceController.fetch(context, fetchRequest: fetchRequest)
    
    @State var currentTrainingSet = trainingSets.first
    @State var popupBool: Bool = false
    
    return PopupFeedbackView(
        currentTrainingSet: $currentTrainingSet,
        presentPopup: $popupBool
    ).environment(\.managedObjectContext, context)
}
