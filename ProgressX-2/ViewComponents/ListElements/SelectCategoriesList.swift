//
//  SelectCategoriesList.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-11.
//

import SwiftUI

struct SelectCategoriesList: View {
    
    @Binding var selectedCategories: Set<ExerciseCategory>
    
    @FetchRequest var categories: FetchedResults<ExerciseCategory>
    
    var body: some View {
        List {
            ForEach(categories) { category in
                HStack {
                    Text(category.categoryName!)
                    Spacer()
                    if selectedCategories.contains(category) {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.blue)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        if selectedCategories.contains(category) {
                            selectedCategories.remove(category)
                        } else {
                            selectedCategories.insert(category)
                        }
                    }
                }
            }
        }
        .cornerRadius(20)
        .frame(width: 250, height: 200)
    }
}

#Preview {
    
    @FetchRequest(
        entity: ExerciseCategory.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ExerciseCategory.categoryName, ascending: false)]
    ) var categories: FetchedResults<ExerciseCategory>
    
    @State var selectedCategories: Set<ExerciseCategory> = Set()
    
    return SelectCategoriesList(
        selectedCategories: $selectedCategories,
        categories: _categories
    )
}
