//
//  InputError.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-08-01.
//

import Foundation
import SwiftUI

public struct ShakeEffect: GeometryEffect {
    
    private var position: CGFloat
    
    public var animatableData: CGFloat {
        get { position }
        set { position = newValue }
    }
    
    init(shakes: Int) {
        position = CGFloat(shakes)
    }

    public func effectValue(size: CGSize) -> ProjectionTransform {
        return ProjectionTransform(CGAffineTransform(translationX: -10 * sin(position * 2 * .pi), y: 0))
    }
    
}
