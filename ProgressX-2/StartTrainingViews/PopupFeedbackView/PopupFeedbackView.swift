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
    @Binding var exercise: Exercise?
    
    @State var text = ""
    @State var ShowWindow: Bool = false
    @Binding var presentPopup: Bool
    
    var body: some View {
        VStack{
            if !ShowWindow {
                
                if ((currentTrainingSet?.exercise?.exerciseType = "reps") != nil) {
                    BoldTitle(text: "Did you complete all your reps?")
                } else if ((currentTrainingSet?.exercise?.exerciseType = "time") != nil){
                    BoldTitle(text: "Did you complete the exercise witin the given timeframe")
                }
                
                HStack{
                    Button(action:{
                        ShowWindow.toggle()
                        changeText(text: "How many reps did you do?")
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
                BoldTitle(text: self.text)
                    .padding(.horizontal, 20)
                
                LightSubHeadline(text: "Out of a total \(currentTrainingSet!.quantityTodoString!)")
                    .padding(.vertical, 5)
                
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
            viewModel.setViewStartValues(selectedTrainigeSet: currentTrainingSet)
        })
        
    }
    func changeText(text: String) {
        self.text = text
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
