//
//  Title2.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-25.
//

import SwiftUI

struct Title2: View {
    
    let text: String
    let alignment: TextAlignment = .center
    
    var body: some View {
        Text(text)
            .foregroundColor(Color("textColor"))
            .font(.title2)
            .scaleEffect(CGSize(width: 1.25, height: 1.25))
            .foregroundColor(.black)
            .multilineTextAlignment(alignment)
            .minimumScaleFactor(0.5)
    }
}

#Preview {
    Title2(text: "Test")
}
