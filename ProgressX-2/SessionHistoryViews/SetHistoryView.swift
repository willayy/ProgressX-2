//
//  SetHistoryView.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-09-14.
//

import Foundation
import SwiftUI
import CoreData

struct SetHistoryView: View {
    
    @Binding var navPath: [Int]
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject private var viewModel = SetHistoryViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var selectedSet: TrainingSet?
    
    var body: some View {
        Text("hej")
    }
}
