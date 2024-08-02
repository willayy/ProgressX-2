//
//  SavingErrorText.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-08-01.
//

import SwiftUI

struct SavingErrorText: View {
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle")
                .frame(width: 20, height: 20)
                .foregroundStyle(.purple)
            Text("Something went wrong trying to save...")
                .multilineTextAlignment(.center)
                .foregroundStyle(.purple)
        }
    }
}

#Preview {
    SavingErrorText()
}
