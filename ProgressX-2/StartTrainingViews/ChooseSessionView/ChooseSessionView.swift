//
//  ChooseSessionView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-08-05.
//

import SwiftUI

struct ChooseSessionView: View {
    
    @Binding var navPath: [Int]
    @Binding var selectedTrainingWeek: TrainingWeek?
    @Binding var selectedTrainingSession: TrainingSession?
    
    var body: some View {
        
        @FetchRequest(
            entity: TrainingSession.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \TrainingSession.positionIndex, ascending: true)],
            predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [
                NSPredicate(format: "trainingWeek == %@", selectedTrainingWeek!),
                NSPredicate(format: "isComplete == %@", NSNumber(value: false))
            ])
        ) var trainingSessions: FetchedResults<TrainingSession>
        
        ScrollView {
            
            VStack(alignment: .center) {
                
                BoldTitle(text: "Weeks in")
                
                Title2(text: selectedTrainingWeek!.timePeriodName!)
                
            }
        }
    }
}
/*
#Preview {
    ChooseSessionView()
}
*/
