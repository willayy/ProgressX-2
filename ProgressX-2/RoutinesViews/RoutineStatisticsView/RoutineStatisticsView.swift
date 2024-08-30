//
//  RoutineStatisticsView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-23.
//

import SwiftUI
import CoreData

struct RoutineStatisticsView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var selectedRoutine: Routine?
    
    var body: some View {
        
        ScrollView {
            
            VStack {
                BoldTitle(text: "Statistics for ")
                    .padding(.horizontal, 20)
                
                Title2(text: "\(selectedRoutine!.timePeriodName!)")
                    .padding(.horizontal, 20)
                
                LightSubHeadline(text: "Here you can view some vital statistics for your routine")
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                
                GroupBox {
                    
                    VStack(alignment: .leading) {
                        
                        (Text("Last session done: ")
                            .fontWeight(.bold)
                         + Text("\(selectedRoutine!.lastSessionDone?.formattedCompletionDate! ?? "No sessions completed")"))
                        .padding(.vertical, 10)
                        
                        (Text("Sessions done the last 30 days: ")
                            .fontWeight(.bold)
                         + Text("\(selectedRoutine!.sessionsDoneLast30Days.count)"))
                        .padding(.bottom, 10)
                        
                        (Text("Sessions done the last 7 days: ")
                            .fontWeight(.bold)
                         + Text("\(selectedRoutine!.sessionsDoneLast7Days.count)"))
                        .padding(.vertical, 10)
                        
                        (Text("Total completed cycles: ")
                            .fontWeight(.bold)
                         + Text("\(selectedRoutine!.completedCycles!.count)"))
                        .padding(.vertical, 10)
                        
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.bottom, 20)
                .padding(.horizontal, 20)
                
                
                BoldSubHeadline(text: "Exercises in your routine")
                
                PieChart(data: selectedRoutine!.exercises)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    .frame(height: 300)
                
                BoldSubHeadline(text: "Muscle groups targeted")
                
                PieChart(data: selectedRoutine!.categories)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    .frame(height: 300)
                
            }
        }
    }
}

#Preview {
    
    let context = PersistenceController.previewViewContext
    
    let fetchRequest: NSFetchRequest<Routine> = Routine.fetchRequest()
    
    let results = CoreDataAccess.fetch(context, fetchRequest: fetchRequest)
    
    @State var routine = results.first
    
    return RoutineStatisticsView(
                selectedRoutine: $routine
           )
            .environment(\.managedObjectContext, context)
}
