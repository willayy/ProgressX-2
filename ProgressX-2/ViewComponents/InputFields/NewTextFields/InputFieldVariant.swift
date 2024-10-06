//
//  InputFieldVariant.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-10-03.
//

import SwiftUI

/// Baseclass for all TextFieldVariants
public class InputFieldVariant: ObservableObject {
    
    public let allowedChars: Set<Character>
    
    public let keyBoardType: UIKeyboardType
    
    public let minScaleFactor: Double
    
    public let maxChars: Int
    
    public let allowEmpty: Bool
    
    @Published public var errorMessage: String = ""
    
    internal init(allowedChars: Set<Character>, keyBoardType: UIKeyboardType, minScaleFactor: Double, maxChars: Int, allowEmpty: Bool) {
        self.allowedChars = allowedChars
        self.keyBoardType = keyBoardType
        self.minScaleFactor = minScaleFactor
        self.maxChars = maxChars
        self.allowEmpty = allowEmpty
    }
    
    public func filterInput(_ new: String) -> String {
        fatalError("Dont instantiate the InputValidator base class!")
    }
    
    public func isValid(_ new: String) -> Bool {
        fatalError("Dont instantiate the InputValidator base class!")
    }
    
    public func onChange(_ new: String) -> String {
        fatalError("Dont instantiate the InputValidator base class!")
    }
    
}
