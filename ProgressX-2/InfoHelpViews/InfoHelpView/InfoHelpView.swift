//
//  InfoHelpView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-19.
//

import SwiftUI

struct InfoHelpView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject private var viewModel = InfoHelpViewModel()
    
    var body: some View {
        SideBarView(
            showMenu: $viewModel.showMenu,
            content: {
            NavigationStack {
                ScrollView {
                    VStack {
                        
                        BoldTitle(text: "Help / Information")
                        
                        LightSubHeadline(text: "Here you can find helpful information and how-to's for how this app works.")
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        
                        Text("How-to's")
                            .font(.title2)
                        
                        ExpandingVStack(
                            title: "Weigh-in's and body tracking") {
                                
                                // MARK: Body weight introduction
                                BoldSubHeadline(text: "Tracking body weight")
                                    .padding(.top, 20)
                                
                                LightSubHeadline(text: "In ProgressX you can track your weight by weighing in using the \"Weigh-in\" button on the Homescreen. Tracking weight is a great way to keep track of your fitness progress regardless if your goal is to put on mass or lose bodyfat.")
                                    .padding(.horizontal, 10)
                                    .padding(.bottom, 10)
                                
                                LightSubHeadline(text: "You can view your weight progress in the Homescreen graph or you can overlay it when viewing personal records for exercises.")
                                    .padding(.bottom, 20)
                                
                                // MARK: Body measurment introduction
                                BoldSubHeadline(text: "Tracking body measurements")
                                    .padding(.bottom, 10)
                                
                                LightSubHeadline(text: "As a supplement to tracking weight ProgressX also gives you the oppurtunity to track body measurements, this gives you a much more detalied view of your fitness progress.")
                                    .padding(.horizontal, 10)
                                    .padding(.bottom, 10)
                                
                                GroupBox {
                                    Image("Body-measurement-diagram")
                                }
                                
                                // MARK: Measurement header
                                BoldSubHeadline(text: "The measurements")
                                
                                LightSubHeadline(text: "ProgressX divides up the body into 6 different segments that can be measured and tracked.")
                                    .padding(.horizontal, 10)
                                    .padding(.bottom, 10)
                                
                                // MARK: Chest circumference explanation
                                HStack {
                                    Circle()
                                        .frame(width: 7, height: 7)
                                    Text("Chest circumference")
                                }
                                LightSubHeadline(text: "This measurement should be taken from under the arm-pits around your chest.")
                                
                                // MARK: Upper arm circumference explanation
                                HStack {
                                    Circle()
                                        .frame(width: 7, height: 7)
                                    Text("Upper arm circumference")
                                }
                                LightSubHeadline(text: "This measurement should be taken at the middle-point between your elbow and your shoulder, around your arm. This should be the thickest part of your upper arm.")
                            
                                // MARK: Lower arm circumference explanation
                                HStack {
                                    Circle()
                                        .frame(width: 7, height: 7)
                                    Text("Lower arm circumference")
                                }
                                LightSubHeadline(text: "This measurement should be taken at the thickest part of the fore-arm right below your elbow.")
                                
                                // MARK: Waist circumference explanation
                                HStack {
                                    Circle()
                                        .frame(width: 7, height: 7)
                                    Text("Waist circumference")
                                }
                                LightSubHeadline(text: "This measurement should be taken right on top of your hip bones.")
                                
                                // MARK: Thigh circumference explanation
                                HStack {
                                    Circle()
                                        .frame(width: 7, height: 7)
                                    Text("Thigh circumference")
                                }
                                LightSubHeadline(text: "This measurement should be taken at the middle-point between your knees and your hip, this should be the thickest part of your thigh.")
                                
                                // MARK: Calf circumference explanation
                                HStack {
                                    Circle()
                                        .frame(width: 7, height: 7)
                                    Text("Calf circumference")
                                }
                                LightSubHeadline(text: "This measurement should be taken at the thickest point of your calf.")
                                    .padding(.bottom, 20)
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 10)
                        
                        ExpandingVStack(
                            title: "Creating and using exercises") {
                                
                                BoldSubHeadline(text: "Creating an Exercise")
                                    .padding(.top, 20)
                                
                                LightSubHeadline(text: "In ProgressX you can create any exercise you want by simply clicking the Exercises tab in the side menu of the app and then clicking the \"Add new exercise\" button.")
                                    .padding(.bottom, 10)
                                
                                LightSubHeadline(text: "Exercises in ProgressX are divided into two broad types, time-based exercises, like planks and static holds, and rep-based exercises, like squats, deadlifts and bench press.")
                                    .padding(.bottom, 20)
                                
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 10)
                        
                        ExpandingVStack(
                            title: "Personal records") {
                                
                                BoldSubHeadline(text: "Personal records")
                                    .padding(.top, 20)
                                
                                LightSubHeadline(text: "In ProgressX a personal record isn't necessarily be the best one you have ever done. Personal records are used to keep track of progress as a whole, with both ups and downs. If set up correctly personal records will be generated automatically as you train, but you can also add them manually on exercises via the the Exercise library tab")
                                
                                BoldSubHeadline(text: "One rep max (1RM)")
                                    .padding(.top, 10)
                                
                                LightSubHeadline(text: "The one rep max is a personal record keeping track of much load (weight) you can lift on an exercise i a single repetition.")
                                
                                BoldSubHeadline(text: "As many reps as possible (AMRAP)")
                                    .padding(.top, 10)
                                
                                LightSubHeadline(text: "The AMRAP pr is a personal record keeping track of how many reps you do on a exercise with a certain weight.")
                                
                                BoldSubHeadline(text: "Time max (Time-max)")
                                    .padding(.top, 10)
                                
                                LightSubHeadline(text: "The Time-max is a personal record keeping track of many seconds you can do on a exercise with a certain weight. ")
                                    .padding(.bottom, 20)
                                
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 10)
                        
                        ExpandingVStack(
                            title: "Creating a training routine") {
                                
                                BoldSubHeadline(text: "Creating a routine")
                                    .padding(.top, 20)
                                
                                LightSubHeadline(text: "In ProgressX you create a routine by selecting routines in the sidemenu of the app and pressing the \"Add new routine\" button.")
                                    .padding(.bottom, 10)
                                
                                BoldSubHeadline(text: "Routine structure")
                                    .padding(.bottom, 10)
                                
                                Image("Routine-hierarchy-diagram")
                                    .padding(.bottom, 10)
                                
                                BoldSubHeadline(text: "Weeks and cycles")
                                
                                LightSubHeadline(text: "A routine can consists of any number of weeks, but we recommend your routine to be between 1-4 weeks. Every time you complete all the weeks in your routine you complete a cycle of that routine.")
                                    .padding(.bottom, 10)
                                
                                BoldSubHeadline(text: "Sessions")
                                
                                LightSubHeadline(text: "A week conssists of any number of sessions. A session is meant to be completed in one go. To simplify a session can be seen as \"Going to the gym once\".")
                                    .padding(.bottom, 10)
                                
                                BoldSubHeadline(text: "Sets")
                                
                                LightSubHeadline(text: "Naturally a gym session consists of sets. Sets consist of an exercise, a load and a quantity. There are some different options for load and quantity.")
                                    .padding(.bottom, 10)
                                
                                LightSubHeadline(text: "The load and quantity can be numerical which means its just a number, like 100 kg's or 200 lbs. In the case of quantity it could be something like 11 reps or 100 seconds.")
                                    .padding(.bottom, 10)
                                
                                LightSubHeadline(text: "The load and quantity can be a percentage of your current personal record, for example 60% of your current 1RM PR might be 95 kg's. In the case of quantity 60% of your current AMRAP PR might equate to 11 reps.")
                                    .padding(.bottom, 10)
                                
                                LightSubHeadline(text: "The load can also be a percentage of your current bodyweight. For example 50% of your current bodyweight might be something like 50 kg's or 100 lbs.")
                                    .padding(.bottom, 10)
                                
                                BoldSubHeadline(text: "Thresholds")
                                
                                LightSubHeadline(text: "Sets in ProgressX has something called thresholds, a threshold is an action that happens when a certain quantity on that set has been achieved.")
                                    .padding(.bottom, 10)
                                
                                LightSubHeadline(text: "A threshold can add or subtract a flat amount of quantity or load to a set when a certain quantity is reached. For example, lets say you do 8 reps on a set with 10 reps total, then you might want to lower the load for next time you do that set so you can do the total of 10 reps.")
                                    .padding(.bottom, 10)
                                
                                LightSubHeadline(text: "A threshold can also create a PR, lets say you have a set of bench press with 1 rep that's always 105% of your current 1RM PR. On this set you would like to have threshold that creates a new PR if you achieve 1 rep. Thresholds can also create 1RM PR's for sets that arent strictly 1 rep using something called Brzyzki's formula..")
                                    .padding(.bottom, 20)
                                
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 10)
                        
                        ExpandingVStack(
                            title: "Starting a workout") {
                                
                                BoldSubHeadline(text: "Starting a workout")
                                    .padding(.top, 20)
                                
                                LightSubHeadline(text: "To start a workout in ProgressX click on the \"Start workout\" tab in the side menu. You can use the default routine to start working out but we recommend you create your own routine before starting your training.")
                                    .padding(.bottom, 20)
                                
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 10)
                        
                        ExpandingVStack(
                            title: "Changing profile settings") {
                            
                                BoldSubHeadline(text: "Changing profile settings")
                                    .padding(.top, 20)
                            
                                LightSubHeadline(text: "To change any profile settings in ProgressX press the \"Profile\" tab in the side menu, its located at the bottom of the menu.")
                                    .padding(.bottom, 20)
                                
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        
                        Text("Other")
                            .font(.title2)
                        
                        ExpandingVStack(
                            title: "Report bugs, Developers, Contact") {
                                
                                BoldSubHeadline(text: "Developers & Contact")
                                    .padding(.top, 20)
                                    .padding(.bottom, 5)
                                
                                LightSubHeadline(text: "William Norland")
                                LightSubHeadline(text: "Contact: williamnorland@gmail.com")
                                    .padding(.bottom, 5)
                                
                                LightSubHeadline(text: "Lucas Häyhänen")
                                LightSubHeadline(text: "Contact: lucas.hayhanen@live.se")
                                    .padding(.bottom, 10)
                                
                                BoldSubHeadline(text: "Bug reports")
                                
                                LightSubHeadline(text: "To report bugs please contact one of the developers of this app.")
                                    .padding(.bottom, 20)
                                
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 10)
                        
                        ExpandingVStack(
                            title: "Data management") {
                                
                                BoldSubHeadline(text: "Data management")
                                    .padding(.top, 20)
                                
                                LightSubHeadline(text: "ProgressX is an offline app that stores all data locally on your device")
                                    .padding(.bottom, 20)
                                
                            }
                            .padding(.horizontal, 20)
                        
                    }.toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            SideBarButton(showMenu: $viewModel.showMenu)
                                .environmentObject(viewRouter)
                        }
                    }
                }
            }
        })
    }
}

#Preview {
    InfoHelpView()
        .environmentObject(ViewRouter())
}
