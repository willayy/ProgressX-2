//
//  AddThresholdsView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-02.
//

import SwiftUI
import CoreData

struct ThresholdsView: View {
    
    @Binding var navPath: [Int]
    @Binding var selectedTemplateSet: TemplateSet?
    @Binding var selectedThreshold: SetThreshold?
    
    var body: some View {
        
        @FetchRequest(
            entity: SetThreshold.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \SetThreshold.triggerQuantity, ascending: true)],
            predicate: NSPredicate(format: "templateSet == %@", selectedTemplateSet!)
        ) var thresholds: FetchedResults<SetThreshold>
        
        ScrollView {
            
            BoldTitle(text: "Adding thresholds for")
                .padding(.horizontal, 20)
            
            Title2(text: "\(selectedTemplateSet!.timePeriodName!)")
            
            BoldSubHeadline(text: "Current thresholds in \(selectedTemplateSet!.timePeriodName!)")
                .padding(.top, 20)
            
            BasicList(
                height: 400,
                containerName: "this set",
                elementName: "threshold",
                data: _thresholds) { threshold in
                    ThresholdListItem(
                        navPath: $navPath,
                        selectedThreshold: $selectedThreshold,
                        threshold: threshold
                    )
                }
                .padding(.horizontal, 20)
            
        }
        
        Button {
            navPath.append(9)
        } label: {
            Text("Add threshold")
                .frame(height: 40)
                .foregroundColor(Color("buttonTextColor"))
            Image(systemName: "plus")
                .foregroundColor(Color("buttonTextColor"))
        }
        .buttonStyle(BorderedProminentButtonStyle())
        .padding(.vertical, 20)

    }
}

#Preview {
    
    let context = PersistenceController.previewViewContext
    let fetchRequest: NSFetchRequest = TemplateSet.fetchRequest()
    let templateSets = CoreDataAccess.fetch(context, fetchRequest: fetchRequest)
    
    @State var templateSet: TemplateSet? = templateSets.first!
    @State var navPath: [Int] = [Int]()
    @State var selectedThreshold: SetThreshold? = nil
    
    return ThresholdsView(
        navPath: $navPath,
        selectedTemplateSet: $templateSet, 
        selectedThreshold: $selectedThreshold)
    .environment(\.managedObjectContext, context)
}
