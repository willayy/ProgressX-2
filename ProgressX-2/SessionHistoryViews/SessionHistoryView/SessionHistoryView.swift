//
//  SessionHistoryView.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-08-14.
//

import Foundation
import SwiftUI
import CoreData

struct SessionHistoryView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject private var viewModel = SessionHistoryViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var selectedTrainingSession: TrainingSession?
    
    var body: some View {
        
        let trainingsets = selectedTrainingSession?.trainingSets?.allObjects as! [TrainingSet]
        
        
        Button {
            
            print(trainingsets.first?.exercise?.exerciseName)
        } label: {
            Text("hej")
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let fetchRequest: NSFetchRequest = TrainingSession.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "isComplete == %@", NSNumber(booleanLiteral: true))
    let trainingSessions = PersistenceController.fetch(context, fetchRequest: fetchRequest)
    
    let trainingSession: TrainingSession? = trainingSessions.first
    
    @State var trainingsession = trainingSession
    return SessionHistoryView( selectedTrainingSession: $trainingsession).environment(\.managedObjectContext, context)
}
