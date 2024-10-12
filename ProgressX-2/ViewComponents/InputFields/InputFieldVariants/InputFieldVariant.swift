//
//  InputFieldVariant.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-10-03.
//

import SwiftUI

/// Baseclass for all TextFieldVariants
public class InputFieldVariant: ObservableObject {
    
    internal let allowedChars: Set<Character>
    
    internal let keyBoardType: UIKeyboardType
    
    internal let minScaleFactor: Double
    
    internal let maxChars: Int
    
    internal let allowEmpty: Bool
    
    @Published public var errorMessage: String = ""
    
    internal init(allowedChars: Set<Character>, keyBoardType: UIKeyboardType, minScaleFactor: Double, maxChars: Int, allowEmpty: Bool) {
        self.allowedChars = allowedChars
        self.keyBoardType = keyBoardType
        self.minScaleFactor = minScaleFactor
        self.maxChars = maxChars
        self.allowEmpty = allowEmpty
    }
    
    internal func filterInput(_ new: String) -> String {
        fatalError("Dont instantiate the InputValidator base class!")
    }
    
    internal func dynamicValidation(_ filtered: String) -> Bool {
        fatalError("Dont instantiate the InputValidator base class!")
    }
    
}
