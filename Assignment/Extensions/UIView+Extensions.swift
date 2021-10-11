//
//  UIView+Extensions.swift
//  Assignment
//
//  Created by Dougherty, Keith on 9/28/21.
//

import Foundation
import UIKit

extension UIView {
    
    /** Returns a collection of constraints to anchor the bounds of the current view to the given view.
        - Parameter view: The view to anchor to.
        - Returns: The layout constraints needed for this constraint.
     */
    func constraintsForAnchoringTo(boundsOf view: UIView) -> [NSLayoutConstraint] {
        return [
            topAnchor.constraint(equalTo: view.topAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]
    }
    
    /// Sets anchor contrainsts for the current view
    func anchor(top : NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat = 0.0,
                bottom : NSLayoutYAxisAnchor? = nil, paddingBottom: CGFloat = 0.0,
                leading: NSLayoutXAxisAnchor? = nil, paddingLeading: CGFloat = 0.0,
                trailing: NSLayoutXAxisAnchor? = nil, paddingtrailing: CGFloat = 0.0,
                width:NSLayoutDimension? = nil, widthMultipler:CGFloat = 0.0,
                height:NSLayoutDimension? = nil, heightMultipler:CGFloat = 0.0) {
            
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top,
                                 constant: paddingTop).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom,
                                    constant: paddingBottom).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading,
                                     constant: paddingLeading).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing,
                                      constant: paddingtrailing).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalTo: width, multiplier: widthMultipler).isActive = true
        }
        
        if let height = height {
            height.constraint(equalTo: height, multiplier: heightMultipler).isActive = true
        }
    }
    
    ///Sets size contraints for the current view
    func setSize(width: CGFloat? = nil, height: CGFloat? = nil)  {
        
        translatesAutoresizingMaskIntoConstraints = false
       
        if let width = width, width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height, height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    ///Sets min size contrainst for the current view
    func setMinSize(width: CGFloat? = nil, height: CGFloat? = nil)  {
        
        translatesAutoresizingMaskIntoConstraints = false
       
        if let width = width, width != 0 {
            widthAnchor.constraint(greaterThanOrEqualToConstant: width).isActive = true
        }
        
        if let height = height, height != 0 {
            heightAnchor.constraint(greaterThanOrEqualToConstant: height).isActive = true
        }
    }
    
}
