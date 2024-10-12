//
//  CreateNewProfile3.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-22.
//

import SwiftUI

struct CreateNewProfile3View: View {
    
    /* Fetch BodyEntries so it can be modified by the input values
     At this state in the app there will only be one BodyEntry, the first one. */
    @FetchRequest(
        entity: BodyEntry.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \BodyEntry.achievedOnDate, ascending: true)]
    ) private var bodyEntries: FetchedResults<BodyEntry>
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var navPath: [Int]
    @StateObject private var viewModel = CreateNewProfile3ViewModel()
    
    var body: some View {
        
        // Input form for PR's on some common exercises
        ScrollView(showsIndicators: false) {
            
            VStack(alignment: .center, spacing: 10) {
                
                Text("Extra information on body measurements")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(viewModel.minScaleFactor);
                
                Text("Optionally fill in all the following fields of measurements for specific body parts, this is only your initial measurements. You can continue to add measurements when weighing-in in the future.")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .minimumScaleFactor(viewModel.minScaleFactor);
                
                // Inputs for body measurements
                VStack(alignment: .center, spacing: 10) {
                    
                    Text("Circumference metrics")
                        .font(.headline)
                    
                    HStack {
                        
                        Text("Chest circumference")
                            .minimumScaleFactor(viewModel.minScaleFactor)
                            .frame(
                                width: viewModel.textWidth,
                                alignment: .leading
                            )
                        
                        Spacer(minLength: 50)
                        
                        InputField(
                            placeHolder: viewModel.lengthUnit(viewContext),
                            text: $viewModel.chestCirc,
                            variant: DecimalIF(
                                min: 0,
                                max: 1000,
                                optional: true
                            )
                        )
                        
                    }
                    
                    HStack {
                        
                        Text("Waist circumference")
                            .minimumScaleFactor(viewModel.minScaleFactor)
                            .frame(
                                width: viewModel.textWidth,
                                alignment: .leading
                            )
                        
                        Spacer(minLength: 50)
                        
                        InputField(
                            placeHolder: viewModel.lengthUnit(viewContext),
                            text: $viewModel.waistCirc,
                            variant: DecimalIF(
                                min: 0,
                                max: 1000,
                                optional: true
                            )
                        )
                        
                    }
                    
                    HStack {
                        
                        Text("Thigh circumference")
                            .minimumScaleFactor(viewModel.minScaleFactor)
                            .frame(
                                width: viewModel.textWidth,
                                alignment: .leading
                            )
                        
                        Spacer(minLength: 50)
                        
                        InputField(
                            placeHolder: viewModel.lengthUnit(viewContext),
                            text: $viewModel.thighCirc,
                            variant: DecimalIF(
                                min: 0,
                                max: 1000,
                                optional: true
                            )
                        )
                        
                    }
                    
                    HStack {
                        
                        Text("Calf circumference")
                            .minimumScaleFactor(viewModel.minScaleFactor)
                            .frame(
                                width: viewModel.textWidth,
                                alignment: .leading
                            )
                        
                        Spacer(minLength: 50)
                        
                        InputField(
                            placeHolder: viewModel.lengthUnit(viewContext),
                            text: $viewModel.calfCirc,
                            variant: DecimalIF(
                                min: 0,
                                max: 1000,
                                optional: true
                            )
                        )
                        
                    }
                    
                    HStack {
                        
                        Text("Lower arm circumference")
                            .minimumScaleFactor(viewModel.minScaleFactor)
                            .frame(
                                width: viewModel.textWidth,
                                alignment: .leading
                            )
                        
                        Spacer(minLength: 50)
                        
                        InputField(
                            placeHolder: viewModel.lengthUnit(viewContext),
                            text: $viewModel.lowerArmCirc,
                            variant: DecimalIF(
                                min: 0,
                                max: 1000,
                                optional: true
                            )
                        )
                
                    }
                    
                    HStack {
                        
                        Text("Upper arm circumference")
                            .minimumScaleFactor(viewModel.minScaleFactor)
                            .frame(
                                width: viewModel.textWidth,
                                alignment: .leading
                            )
                        
                        Spacer(minLength: 50)
                        
                        InputField(
                            placeHolder: viewModel.lengthUnit(viewContext),
                            text: $viewModel.upperArmCirc,
                            variant: DecimalIF(
                                min: 0,
                                max: 1000,
                                optional: true
                            )
                        )
                        
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal, 30)
                
            }
        }
        
        HStack {
            
            // MARK: Skip this segment button
            Button {
                
                navPath.append(3)
                
            } label: {
                
                Text("Skip this")
                    .frame(width: 100, height: 40)
                    .foregroundColor(Color("buttonTextColor"))
                
            }
            .buttonStyle(.borderedProminent)
            .padding(.vertical, 20)
            .tint(.red.opacity(0.9))
            
            // MARK: Continue (after providing input) button
            Button {
                
                if GlobalInputFieldValidator.allFieldsValid() {
                    
                    viewModel.firstBodyEntry = bodyEntries.first
                    
                    viewModel.saveEntry(viewContext: viewContext)
                    
                    navPath.append(3)
                    
                }
                
            } label: {
                
                Text("Continue")
                    .frame(width: 80, height: 40)
                    .foregroundColor(Color("buttonTextColor"))
                
                Image(systemName: "arrow.right")
                    .foregroundColor(Color("buttonTextColor"))
            }
            .buttonStyle(.borderedProminent)
            .padding(.vertical, 20)
            
        }
        
    }
    
}

#Preview {
    
    let context = PersistenceController.previewViewContext
    
    @State var navPath = [Int]()
    
    return CreateNewProfile3View(navPath: $navPath)
       .environment(\.managedObjectContext, context)
}
