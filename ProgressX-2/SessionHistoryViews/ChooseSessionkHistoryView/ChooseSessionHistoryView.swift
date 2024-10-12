//
//  ChooseWeekView.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-08-12.
//


import SwiftUI

struct ChooseSessionkHistoryView: View {
    
    @StateObject private var viewModel = ChooseSessionHistoryViewModel()
    
    @FetchRequest(
        entity: TrainingSession.entity(),
        sortDescriptors: [],
        predicate: NSPredicate(format: "isComplete == %@", NSNumber(booleanLiteral: true))
    ) var allCompletedSessions: FetchedResults<TrainingSession>
    
    var body: some View {
        
        SessionHistoryNavigationController(navPath: $viewModel.navPath,
                                           selectedTrainingSession: $viewModel.selectedTrainingSession,
                                           content: {
            
            ScrollView {
                
                VStackWithSideBarButton{
                    
                    BoldTitle(text:"Completed sessions")
                    
                    LightSubHeadline(text: "Here you can choose a specific completed session to view your past workouts")
                        .padding(.bottom, 10)
                        .padding(.horizontal, 20)
                    
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
                            selectedTrainingSession: $viewModel.selectedTrainingSession,
                            session: session
                        )
                    }
                    .padding(.horizontal, 20)
                    
                }
                
            }
            
        })
        
    }
    
}

#Preview {

    let context = PersistenceController.previewViewContext
    
    return ChooseSessionkHistoryView()
        .environmentObject(ShowMenuController())
        .environment(\.managedObjectContext, context)
        
}
