//
//  LocalizedStrings.swift
//  Assignment
//
//  Created by Dougherty, Keith on 10/9/21.
//

import Foundation

class LocalizedString {
    
    static var lastUpdatedTitle =  NSLocalizedString("list.lastUpdatedTitle", value: "Last Updated", comment: "List last updated date title")

    static var positions: String = NSLocalizedString("list.title", value: "Positions", comment: "List title")

    static var criteria = NSLocalizedString("detail.criteria", value: "Criteria:", comment: "Detail Position Criteria Title Label")
    static var positionName = NSLocalizedString("detail.name", value: "Name:", comment: "Detail Position Name Title Label")
    static var price = NSLocalizedString("detail.price", value: "Latest Price:", comment: "Detail Position Price Title Label")
    static var quantity = NSLocalizedString("detail.positions", value: "Available Positions:", comment: "Detail Position Positions Title Label")
    
}
