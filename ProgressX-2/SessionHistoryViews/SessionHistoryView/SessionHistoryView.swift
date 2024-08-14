//
//  SessionHistoryView.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-08-14.
//

import Foundation
import SwiftUI

struct SessionHistoryView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject private var viewModel = SessionHistoryViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        
        Text("hej")
        
    }
}
