//
//  HeaderSupplementaryView.swift
//  Assignment
//
//  Created by Dougherty, Keith on 9/29/21.
//

import Foundation
import UIKit

/**
 Manages the Collection View Cell to display details for the `List View`.
 */
class SectionHeaderReusableView: UICollectionReusableView {

    // MARK: - Public Properties
    
    /// property used to display the `Title`
    var title:String = "" {
        didSet {
            self.titleLabel.text = title
        }
    }
    
    // MARK: - Private Properties
    private let titleLabel: UILabel = UIManager.Label(.title2, bold: true)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
      
        addSubview(titleLabel)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
              NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
                titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -5)])
        } else {
              NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor),
                titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: readableContentGuide.trailingAnchor)
              ])
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

