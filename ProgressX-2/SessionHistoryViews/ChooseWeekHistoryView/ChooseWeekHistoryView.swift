//
//  ChooseWeekView.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-08-12.
//

import Foundation
import SwiftUI
import CoreData

struct ChooseWeekHistoryView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject private var viewModel = ChooseWeekHistoryViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: TrainingSession.entity(),
        sortDescriptors: [],
        predicate: NSPredicate(format: "isComplete == %@", NSNumber(booleanLiteral: true))
    ) var allCompletedSessions: FetchedResults<TrainingSession>
    
    var body: some View {
        
        SessionHistoryNavigationController(navPath: $viewModel.navPath, content: {
            
            ScrollView{
                
                VStackWithSideBarButton{
                    
                    BoldTitle(text:"Completetd sessions")
                    
                    LightSubHeadline(text: "Here you can choose a specific completed session to view your past workouts")
                        .padding(.vertical)
                        .padding(.horizontal)
                    
                    // MARK: Search bar
                    SearchBar(
                        searchAttribute: "timePeriodName",
                        searchText: $viewModel.searchText,
                        fetchRequest: _allCompletedSessions
                    )
                    .padding(.horizontal, 20)
                    
                    BasicList(
                        height: 400,
                        containerName: "",
                        elementName: "sessions",
                        data: _allCompletedSessions)
                    { session in
                        TrainingSessionHistoryListItem(
                            navPath: $viewModel.navPath,
                            selectedTrainingSession: $viewModel.selectedTrainingSession, session: session
                        )
                    }.padding(.horizontal, 20)
                }
            }
        }, selectedTrainingSession: $viewModel.selectedTrainingSession)
    }
}

#Preview {

    let context = PersistenceController.previewViewContext
    
    return ChooseWeekHistoryView()
        .environmentObject(ShowMenuController())
        .environment(\.managedObjectContext, context)
        

        
}
