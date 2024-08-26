//
//  DisplayMusclesDummy.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-08-26.
//

import SwiftUI

struct DisplayMusclesDummy: View {
    
    @Binding var selectedMuscles: Set<ExerciseCategory>
    
    @FetchRequest var categories: FetchedResults<ExerciseCategory>
    
    var body: some View {
        let selectedcategoryarray = Array(selectedMuscles)
        
        ZStack {
                Image("Base")
                    .resizable()
                    .padding(.horizontal, 40)
                    .padding(.top)
                    .frame(height: 300)
                ForEach(selectedcategoryarray) { category in
                    if selectedMuscles.contains(category){
                        Image(category.categoryName!)
                            .resizable()
                            .padding(.horizontal, 40)
                            .padding(.top)
                            .frame(height: 300)
                    }
                    
            }
        }
    }
}
