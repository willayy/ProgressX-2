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
        
        PieChart(data: SetsForChart(sets: trainingsets))
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .frame(height: 300)
        
        Button {
            
            (trainingsets.first?.exercise?.exerciseName)
        } label: {
            Text("hej")
        }
    }
    
    public func SetsForChart(sets: [TrainingSet]) -> [String:Int]{
        let completed = 0
        let uncompleted = 0
        var colection:[String:Int] = ["completed":0, "uncompleted": 0]
        for trainingset in sets{
            if trainingset.loadDone < trainingset.loadTodo{
                colection.updateValue(completed + 1, forKey: "uncompleted")
            } else {
                colection.updateValue(completed + 1, forKey: "completed")
            }
        }
        return colection
    }
}

#Preview {
    let context = PersistenceController.previewViewContext
    let fetchRequest: NSFetchRequest = TrainingSession.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "isComplete == %@", NSNumber(booleanLiteral: true))
    let trainingSessions = CoreDataAccess.fetch(context, fetchRequest: fetchRequest)
    
    let trainingSession: TrainingSession? = trainingSessions.first
    
    @State var trainingsession = trainingSession
    return SessionHistoryView( selectedTrainingSession: $trainingsession)
        .environment(\.managedObjectContext, context)
}
