//
//  ProgressBar.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-08-07.
//

import SwiftUI

struct ProgressBar: View {
    
    var height: CGFloat
    var progress: Double

    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack(alignment: .leading) {
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(maxWidth: .infinity)
                    .frame(height: height)
                    .foregroundColor(Color.gray.opacity(0.3))
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(
                        width: CGFloat(progress) * geometry.size.width,
                        height: height
                    )
                    .foregroundColor(.blue)
                    .animation(.linear, value: progress)
            }
        }
    }
}

#Preview {
    ProgressBar(height: 5, progress: 0.5)
}
