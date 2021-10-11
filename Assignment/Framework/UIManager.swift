//
//  UIManager.swift
//  Assignment
//
//  Created by Dougherty, Keith on 9/30/21.
//

import Foundation
import UIKit

final class UIManager {

    class func Label(_ textStyle:UIFont.TextStyle, bold:Bool = false) -> UILabel {
        
        let label = UILabel(frame: .zero)
        if bold {
            label.font = UIFont.preferredFont(forTextStyle: textStyle).bold()
        } else {
            label.font = UIFont.preferredFont(forTextStyle: textStyle)
        }
        
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }
    
    static func SearchBar() -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.font = UIFont.preferredFont(forTextStyle: .body)
        searchBar.searchTextField.adjustsFontForContentSizeCategory = true
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return searchBar
    }
}
