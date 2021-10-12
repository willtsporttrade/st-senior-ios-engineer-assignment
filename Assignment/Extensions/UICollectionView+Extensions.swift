//
//  UICollectionView+Extensions.swift
//  Assignment
//
//  Created by Dougherty, Keith on 9/28/21.
//

import Foundation
import UIKit

extension UICollectionView.CellRegistration {
    /**
    Returns a dequeued collection view cell at indexPath
    */
    var cellProvider: (UICollectionView, IndexPath, Item) -> Cell {
        return { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(using: self, for: indexPath, item: item)
        }
    }
}

extension UICollectionView.SupplementaryRegistration {
    /**
    Returns a dequeued collection view supplementary view at indexPath
    */
    var headerProvider: (UICollectionView, String, IndexPath) -> Supplementary {
        return { collectionView, string, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(using: self, for: indexPath)
        }
    }
}
