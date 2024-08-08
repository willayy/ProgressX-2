//
//  MagnifiedExerciseView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-11.
//

import SwiftUI

struct MagnifiedExerciseView: View {
        
    @ObservedObject var exercise: Exercise
    
    var body: some View {
        VStack(alignment: .leading, content: {
            Text(exercise.exerciseName ?? "")
                .font(.title)
            .padding(.horizontal, 20)
            
            (Text("Type: ")
                .fontWeight(.bold)
            + Text("\(exercise.exerciseType ?? "")"))
            .minimumScaleFactor(0.6)
            .padding(.horizontal, 20)
            
            (Text("Description: ")
                .fontWeight(.bold)
            + Text("\(exercise.exerciseDesc ?? "")"))
            .minimumScaleFactor(0.6)
            .padding(.horizontal, 20)
            
            (Text("Categories: ")
                .fontWeight(.bold)
             + Text(exercise.categoryString ?? "No categories"))
            .minimumScaleFactor(0.6)
            .padding(.horizontal, 20)
        })
    }
}
