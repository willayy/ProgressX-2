//
//  RoutineStatisticsView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-23.
//

import SwiftUI
import CoreData

struct RoutineStatisticsView: View {
    
    @StateObject private var viewModel = RoutineStatisticsViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var selectedRoutine: Routine?
    
    var body: some View {
        ScrollView {
            VStack {
                BoldTitle(text: "Statistics for: \(selectedRoutine!.timePeriodName!)")
                
                LightSubHeadline(text: "Here you can view some vital statistics for your routine")
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)

                //BoldSubHeadline(text: "General information")
                
                GroupBox {
                    VStack(alignment: .leading) {
                        (Text("Last session done: ")
                            .fontWeight(.bold)
                         + Text("\(selectedRoutine!.lastSessionDone?.completionDateString! ?? "No sessions completed")"))
                        .padding(.vertical, 10)
                        
                        (Text("Sessions done this month: ")
                            .fontWeight(.bold)
                         + Text("\(selectedRoutine!.sessionsDoneThisMonth.count)"))
                        .padding(.bottom, 10)
                        
                        (Text("Sessions done this week: ")
                            .fontWeight(.bold)
                         + Text("\(selectedRoutine!.sessionsDoneThisWeek.count)"))
                        .padding(.vertical, 10)
                        
                        (Text("Total completed cycles: ")
                            .fontWeight(.bold)
                         + Text("\(selectedRoutine!.completedCycles.count)"))
                        .padding(.vertical, 10)
                        
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 20)
                .padding(.horizontal, 20)
                
                
                BoldSubHeadline(text: "Exercises in your routine")
                
                PieChart(data: selectedRoutine!.exerciseInRoutine)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                
                BoldSubHeadline(text: "Muscle groups targeted")
                
                PieChart(data: selectedRoutine!.categoriesInRoutine)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                
            }
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    
    let fetchRequest: NSFetchRequest<Routine> = Routine.fetchRequest()
    
    let results = PersistenceController.fetch(context, fetchRequest: fetchRequest)
    
    @State var routine = results.first
    
    return RoutineStatisticsView(
                selectedRoutine: $routine
           )
            .environment(\.managedObjectContext, context)
}
