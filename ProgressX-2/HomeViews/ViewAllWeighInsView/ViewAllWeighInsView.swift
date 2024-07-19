//
//  EditWeighInView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-18.
//

import SwiftUI

struct ViewAllWeighInsView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var selectedBodyEntry: BodyEntry?
    @Binding var navPath: [Int]
    
    @FetchRequest(
        entity: BodyEntry.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \BodyEntry.achievedOnDate, ascending: false)]
    ) private var bodyEntries: FetchedResults<BodyEntry>
    
    var body: some View {
        ScrollView {
            VStack {
                BoldTitle(text: "Weigh-in's")
                
                LightSubHeadline(text: "Here you can modify, view and delete your weigh-in's")
                    .padding(.bottom, 20)
                
                BasicList(
                    height: 600,
                    containerName: "your Weigh in's",
                    elementName: "entries",
                    data: _bodyEntries) { bodyEntry in
                        BodyEntryListItem(
                            bodyEntry: bodyEntry,
                            selectedBodyEntry: $selectedBodyEntry,
                            navPath: $navPath
                        )
                    }
                    .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    
    let context = PersistenceController.preview.container.viewContext
    @State var navPath: [Int] = [Int]()
    @State var selectedBodyEntry: BodyEntry?
    
    return ViewAllWeighInsView(
        selectedBodyEntry: $selectedBodyEntry,
        navPath: $navPath
    )
    .environment(\.managedObjectContext, context)
}
