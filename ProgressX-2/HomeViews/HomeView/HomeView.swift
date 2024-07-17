//
//  ContentView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-12.
//

import SwiftUI
import CoreData

struct HomeView: View {
        
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject private var viewModel = HomeViewModel()
    
    // Fetch all stored profiles (Should only ever be one stored)
    @FetchRequest(
        entity: Profile.entity(),
        sortDescriptors: []
    ) private var profiles: FetchedResults<Profile>
    
    // Fetch all stored BodyEntries
    @FetchRequest(
        entity: BodyEntry.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \BodyEntry.achievedOnDate, ascending: true)]
    ) private var bodyEntries: FetchedResults<BodyEntry>
    
    var body: some View {
        SideBarView(content: {
            HomeViewNavigationController(content: {
                ScrollView {
                    VStack(alignment: .center) {
                        
                        let profile: Profile = profiles.first!
                        
                        BoldTitle(text: "Home")
                        
                        LightSubHeadline(text: "Welcome back \(profile.profileUserName!)!")
                            .padding(.bottom, 20)
                        
                        // MARK: General information
                        GroupBox {
                            VStack(alignment: .leading) {
                                
                                (Text("Last session done: ")
                                    .fontWeight(.bold)
                                 + Text("\(profile.lastCompletedSession?.completionDateString ?? "No sessions completed.")"))
                                .padding(.vertical, 5)
                                
                                (Text("Last routine trained: ")
                                    .fontWeight(.bold)
                                 + Text("\(profile.lastRoutineUsed?.timePeriodName! ?? "No sessions completed.")"))
                                .padding(.vertical, 5)
                                
                                (Text("Last weigh in: ")
                                    .fontWeight(.bold)
                                 + Text("\(profile.lastWeighIn?.dateString ?? "No weigh-ins done")"))
                                .padding(.vertical, 5)
                                
                            }
                            .frame(width: 300)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 5)
                        
                        // MARK: Current weight and weigh in
                        GroupBox {
                            VStack(alignment: .center) {
                                
                                let weightUnit = PersistenceController.getWeightUnit(viewContext)!
                                
                                (Text("Current weight: ")
                                    .fontWeight(.bold)
                                 + Text("\(String(format: "%.2f", profile.lastWeighIn?.bodyWeight ?? 0)) \(weightUnit)"))
                                .padding(.vertical, 10)
                                
                                BodyEntryChart(bodyEntryData: bodyEntries.map({$0}))
                                    .frame(height: 300)
                                    .padding(.bottom, 5)
                                
                                Button {
                                    viewModel.navPath.append(1)
                                } label: {
                                    Text("Weigh in")
                                        .frame(width: 275)
                                        .padding(.bottom, 5)
                                }
                                .buttonStyle(BorderedProminentButtonStyle())
                                
                            }
                            .frame(width: 300)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                        
                        // MARK: Sessions done this week
                        GroupBox {
                            VStack(alignment: .center) {
                                
                                (Text("Sessions done this week: ")
                                    .fontWeight(.bold)
                                 + Text("\(profile.sessionsCompletedThisWeek.count)"))
                                .padding(.vertical, 10)
                                
                                WeekBarChart(trainingSessions: profile.sessionsCompletedThisWeek)
                                
                            }
                            .frame(width: 300)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                        
                        // MARK: Sessions done the last 30 days
                        GroupBox {
                            VStack(alignment: .center) {
                                
                                (Text("Sessions done last 30 days: ")
                                    .fontWeight(.bold)
                                 + Text("\(profile.sessionsCompletedLast30days.count)"))
                                .padding(.vertical, 10)
                                
                                Last30DaysBarChart(trainingSessions: profile.sessionsCompletedLast30days)
                                
                            }
                            .frame(width: 300)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                        
                    }
                    .frame(maxWidth: .infinity)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            SideBarButton(showMenu: $viewModel.showMenu)
                                .environmentObject(viewRouter)
                        }
                    }
                }
            }, 
            navPath: $viewModel.navPath, profile: $viewModel.selectedProfile)
            .environmentObject(viewRouter)
            .environment(\.managedObjectContext, viewContext)
        }, 
        showMenu: $viewModel.showMenu)
        .environmentObject(viewRouter)
    }
}

#Preview {
    
    let context = PersistenceController.preview.container.viewContext
    
    return HomeView()
        .environmentObject(ViewRouter())
        .environment(\.managedObjectContext, context)
}
