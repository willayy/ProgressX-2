//
//  ContentView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-12.
//

import SwiftUI
import CoreData

struct HomeView: View {
        
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
    
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        HomeViewNavigationController(
            navPath: $viewModel.navPath,
            profile: $viewModel.selectedProfile,
            selectedBodyEntry: $viewModel.selectedBodyEntry,
            content: {
            ScrollView {
                VStackWithSideBarButton {
                    
                    let profile: Profile = profiles.first!
                    
                    BoldTitle(text: "Home")
                        .padding(.horizontal, 20)
                    
                    LightSubHeadline(text: "Welcome back \(profile.profileUserName!)!")
                        .padding(.bottom, 20)
                        .padding(.horizontal, 20)
                    
                    // MARK: General information
                    GroupBox {
                        VStack(alignment: .leading) {
                            
                            (Text("Last session done: ")
                                .fontWeight(.bold)
                             + Text("\(profile.getLastCompletedSession?.formattedCompletionDate ?? "No sessions completed.")"))
                            .padding(.vertical, 5)
                            
                            (Text("Last routine trained: ")
                                .fontWeight(.bold)
                             + Text("\(profile.getLastRoutineUsed?.timePeriodName! ?? "No sessions completed.")"))
                            .padding(.vertical, 5)
                            
                            (Text("Last weigh in: ")
                                .fontWeight(.bold)
                             + Text("\(profile.getLastWeighIn?.dateString ?? "No weigh-ins done")"))
                            .padding(.vertical, 5)
                            
                        }
                        .frame(width: 300)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 5)
                    
                    // MARK: Current weight and weigh in
                    GroupBox {
                        VStack(alignment: .center) {
                            
                            (Text("Current weight: ")
                                .fontWeight(.bold)
                             + Text("\(String(format: "%.2f", profile.getLastWeighIn?.bodyWeight ?? 0)) \(viewModel.weightUnit(viewContext))"))
                            .padding(.vertical, 10)
                            
                            BodyEntryChart(bodyEntryData: bodyEntries.map({$0}))
                                .frame(height: 300)
                                .padding(.bottom, 5)
                            
                            Button {
                                viewModel.navPath.append(1)
                            } label: {
                                Text("Weigh in")
                                    .frame(maxWidth: .infinity)
                                    .padding(.bottom, 5)
                                    .foregroundColor(Color("buttonTextColor"))
                                
                                Image(systemName: "plus")
                                    .foregroundColor(Color("buttonTextColor"))
                            }
                            .buttonStyle(BorderedProminentButtonStyle())
                            
                            Button {
                                viewModel.navPath.append(2)
                            } label: {
                                Text("View all weigh-in's")
                                    .frame(maxWidth: .infinity)
                                    .padding(.bottom, 5)
                                    .foregroundColor(Color("buttonTextColor"))
                                
                                Image(systemName: "pencil")
                                    .foregroundColor(Color("buttonTextColor"))
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
                             + Text("\(profile.getSessionsCompletedThisWeek.count)"))
                            .padding(.vertical, 10)
                            
                            WeekBarChart(trainingSessions: profile.getSessionsCompletedThisWeek)
                            
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
                             + Text("\(profile.getSessionsCompletedLast30days.count)"))
                            .padding(.vertical, 10)
                            
                            Last30DaysBarChart(trainingSessions: profile.getSessionsCompletedLast30days)
                            
                        }
                        .frame(width: 300)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                }
                .frame(maxWidth: .infinity)
            }
        })
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    
    return HomeView()
        .environment(\.managedObjectContext, context)
        .environmentObject(ShowMenuController())
}
