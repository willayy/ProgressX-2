//
//  PrList.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-05-24.
//

import SwiftUI

struct PrList: View {
    var body: some View {
        VStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.gray)
                .opacity(0.4)
            List {
                //TODO: Implement a list of prs that can be edited and added to, editing can be a simple alert box.
            }
        }
    }
}

#Preview {
    PrList()
}
