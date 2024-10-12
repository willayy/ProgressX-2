//
//  NumericInputFieldVariant.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-10-07.
//

import SwiftUI

public class NumericInputFieldVariant: InputFieldVariant {
    
    static private var allowedChars: Set<Character> = [
        "0",
        "1",
        "2",
        "3",
        "4",
        "5",
        "6",
        "7",
        "8",
        "9",
        ".",
        ","
    ]
    
    internal let max: Double
    
    internal let min: Double
    
    internal let allowNegatives: Bool
    
    internal let bwButton: Bool
    
    internal init(
        minScaleFactor: Double,
        maxChars: Int,
        allowEmpty: Bool,
        bwButton: Bool,
        allowNegatives: Bool,
        max: Double,
        min: Double
    ) {
        
        self.min = min
        
        self.max = max
        
        self.allowNegatives = allowNegatives
        
        self.bwButton = bwButton
        
        if allowNegatives { NumericInputFieldVariant.allowedChars.insert("-") }
        
        super.init(
            allowedChars: NumericInputFieldVariant.allowedChars,
            keyBoardType: .numbersAndPunctuation,
            minScaleFactor: 0.75,
            maxChars: maxChars,
            allowEmpty: allowEmpty
        )
    
    }
    
    
}
