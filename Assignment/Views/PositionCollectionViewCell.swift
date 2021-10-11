//
//  PositionCollectionViewCell.swift
//  Assignment
//
//  Created by Dougherty, Keith on 9/29/21.
//

import Foundation
import UIKit


/**
 Manages the Collection View Cell to display details for the `List View`.
 */
class PositionCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Public Properties
     
    /// property used to display the `name`
    var name:String = "" {
        didSet { lblName.text = name }
    }
    
    /// property used to display the `price`
    var price:String = "" {
        didSet { lblPrice.text = price }
    }
    
    // MARK: - Private Properties
    private let lblName:UILabel = UIManager.Label(.body)
    private let lblPrice:UILabel = UIManager.Label(.body)
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// Extension separating private functions for cell configuration
extension PositionCollectionViewCell {
    
    private func configureView() {

        contentView.addSubview(lblName)
        contentView.addSubview(lblPrice)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate(contentView.constraintsForAnchoringTo(boundsOf: self))

        lblName.anchor(top:readableContentGuide.topAnchor,
                       bottom: readableContentGuide.bottomAnchor,
                       leading: readableContentGuide.leadingAnchor,
                       width: contentView.widthAnchor, widthMultipler: 0.66)
        
        lblPrice.anchor(top:readableContentGuide.topAnchor,
                        bottom: readableContentGuide.bottomAnchor,
                        leading: lblName.readableContentGuide.trailingAnchor,
                        trailing: readableContentGuide.trailingAnchor)
    }
}
