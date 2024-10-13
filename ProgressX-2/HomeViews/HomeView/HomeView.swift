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
    
    @Binding public var navPath: [Int]
    
    @Binding public var profile: Profile?
    
    @Binding public var selectedBodyEntry: BodyEntry?
    
    // This is only needed to get access to weightUnit methods
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        
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
                         + Text("\(profile.lastSessionDone?.formattedCompletionDate ?? "No sessions completed.")"))
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
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 5)
                
                // MARK: Current weight and weigh in
                GroupBox {
                    
                    VStack(alignment: .center) {
                        
                        let weightUnit = viewModel.weightUnit(viewContext)
                        
                        (
                            Text("Current weight: ")
                                .fontWeight(.bold)
                            + Text("\(String(format: "%.2f", profile.lastWeighIn?.bodyWeight ?? 0)) \(weightUnit)")
                        )
                        .padding(.vertical, 10)
                        
                        BodyEntryChart(bodyEntryData: bodyEntries.map({$0}))
                            .frame(height: 300)
                            .padding(.bottom, 5)
                        
                        // MARK: Weigh in button
                        Button {
                            
                            navPath.append(1)
                            
                        } label: {
                            
                            Text("Weigh in")
                                .frame(maxWidth: .infinity)
                                .padding(.bottom, 5)
                                .foregroundColor(Color("buttonTextColor"))
                            
                            Image(systemName: "plus")
                                .foregroundColor(Color("buttonTextColor"))
                            
                        }
                        .buttonStyle(BorderedProminentButtonStyle())
                        
                        // MARK: View all past weigh in's button
                        Button {
                            
                           navPath.append(2)
                            
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
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                
                // MARK: Sessions done this week
                GroupBox {
                    VStack(alignment: .center) {
                        
                        (Text("Sessions done this week: ")
                            .fontWeight(.bold)
                         + Text("\(profile.sessionsDoneThisWeek.count)"))
                        .padding(.vertical, 10)
                        
                        WeekBarChart(trainingSessions: profile.sessionsDoneThisWeek)
                        
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                
                // MARK: Sessions done the last 30 days
                GroupBox {
                    VStack(alignment: .center) {
                        
                        (Text("Sessions done last 30 days: ")
                            .fontWeight(.bold)
                         + Text("\(profile.sessionsDoneLast30Days.count)"))
                        .padding(.vertical, 10)
                        
                        Last30DaysBarChart(trainingSessions: profile.sessionsDoneLast30Days)
                        
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
            }
            .frame(maxWidth: .infinity)
        }
        
    }
    
}

#Preview {
    
    let context = PersistenceController.previewViewContext
    
    @State var navPath: [Int] = [Int]()
    
    @State var selectedProfile: Profile? = nil
    
    @State var selectedBodyEntry: BodyEntry? = nil
    
    return HomeView(
        navPath: $navPath,
        profile: $selectedProfile,
        selectedBodyEntry: $selectedBodyEntry
    )
        .environment(\.managedObjectContext, context)
        .environmentObject(ShowMenuController())
}
