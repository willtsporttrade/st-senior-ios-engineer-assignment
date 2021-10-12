//
//  UIFont+Extensions.swift
//  Assignment
//
//  Created by Dougherty, Keith on 10/8/21.
//

import Foundation
import UIKit

extension UIFont {
    /**
     Updates the current font with specified `traits`
     */
    func withTraits(traits:UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0) //size 0 means keep the size as it is
    }

    /**
     Updates the current font by setting it to use bold 
     */
    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
}
