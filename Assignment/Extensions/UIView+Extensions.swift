//
//  UIView+Extensions.swift
//  Assignment
//
//  Created by Dougherty, Keith on 9/28/21.
//

import Foundation
import UIKit

extension UIView {
    
    /// Returns a collection of constraints to anchor the bounds of the current view to the given view.
    ///
    /// - Parameter view: The view to anchor to.
    /// - Returns: The layout constraints needed for this constraint.
    func constraintsForAnchoringTo(boundsOf view: UIView) -> [NSLayoutConstraint] {
        return [
            topAnchor.constraint(equalTo: view.topAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]
    }
    
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
    
    func setSize(width: CGFloat? = nil, height: CGFloat? = nil)  {
        
        translatesAutoresizingMaskIntoConstraints = false
       
        if let width = width, width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height, height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func setMinSize(width: CGFloat? = nil, height: CGFloat? = nil)  {
        
        translatesAutoresizingMaskIntoConstraints = false
       
        if let width = width, width != 0 {
            widthAnchor.constraint(greaterThanOrEqualToConstant: width).isActive = true
        }
        
        if let height = height, height != 0 {
            heightAnchor.constraint(greaterThanOrEqualToConstant: height).isActive = true
        }
    }
    
    
    func setMaxSize(width: CGFloat? = nil, height: CGFloat? = nil)  {
        
        translatesAutoresizingMaskIntoConstraints = false
       
        if let width = width, width != 0 {
            widthAnchor.constraint(lessThanOrEqualToConstant: width).isActive = true
        }
        
        if let height = height, height != 0 {
            heightAnchor.constraint(lessThanOrEqualToConstant: height).isActive = true
        }
    }
    
    func center(centerX: NSLayoutXAxisAnchor? = nil, paddingX: CGFloat = 0.0   ,
                centerY: NSLayoutYAxisAnchor? = nil, paddingY: CGFloat = 0.0)  {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let centerX = centerX {
         centerXAnchor.constraint(equalTo: centerX,
                                  constant: paddingX).isActive = true
        }
        
        if let centerY = centerY {
         centerYAnchor.constraint(equalTo: centerY,
                                  constant: paddingY).isActive = true
        }
        
    }
    
    func proportionalSize(width: NSLayoutDimension? = nil , widthPercent: CGFloat = 1.0,
                          height: NSLayoutDimension? = nil, heightPercent: CGFloat = 1.0) {
            
        translatesAutoresizingMaskIntoConstraints = false
        
        if  let width = width {
            widthAnchor.constraint(equalTo: width,
                                   multiplier: widthPercent).isActive = true
        }
        
        if  let height = height {
            heightAnchor.constraint(equalTo: height,
                                    multiplier: heightPercent).isActive = true
        
        }
    }
}

extension NSLayoutConstraint {
    
    /// Returns the constraint sender with the passed priority.
    ///
    /// - Parameter priority: The priority to be set.
    /// - Returns: The sended constraint adjusted with the new priority.
    func usingPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
    
}

extension UILayoutPriority {
    
    /// Creates a priority which is almost required, but not 100%.
    static var almostRequired: UILayoutPriority {
        return UILayoutPriority(rawValue: 999)
    }
    
    /// Creates a priority which is not required at all.
    static var notRequired: UILayoutPriority {
        return UILayoutPriority(rawValue: 0)
    }
}

@propertyWrapper
public struct UsesAutoLayout<T: UIView> {
    public var wrappedValue: T {
        didSet {
            wrappedValue.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
        wrappedValue.translatesAutoresizingMaskIntoConstraints = false
    }
}

