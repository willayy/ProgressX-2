//
//  AddThresholdsView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-02.
//

import SwiftUI
import CoreData

struct AddThresholdsView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var selectedTemplateSet: TemplateSet?
    
    var body: some View {
        #warning("TODO: Implement AddThresholdsView")
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    
    let context = PersistenceController.preview.container.viewContext
    let fetchRequest: NSFetchRequest = TemplateSet.fetchRequest()
    let templateSets = PersistenceController.fetch(context, fetchRequest: fetchRequest)
    @State var templateSet: TemplateSet? = templateSets.first!
    
    return AddThresholdsView(selectedTemplateSet: $templateSet)
}
