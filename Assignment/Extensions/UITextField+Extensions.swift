//
//  UITextField++Extensions.swift
//  Assignment
//
//  Created by Dougherty, Keith on 10/8/21.
//

import Foundation
import Combine
import UIKit

///Extension to add a publisher
extension UITextField {
    
    /// Publisher used to emit text changes
    var textPublisher: AnyPublisher<String?, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .map(\.object)
            .map { $0 as! UITextField }
            .map(\.text)
            .eraseToAnyPublisher()
    }
}
