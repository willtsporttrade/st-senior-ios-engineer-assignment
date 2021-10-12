//
//  PositionModel.swift
//  Assignment
//
//  Created by William Towe on 9/26/21.
//  Copyright 2021 Sporttrade, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import SwiftyJSON

/**
 Represents a position.
 */
struct PositionModel: JSONEncodable {
    // MARK: - Private Types
    private enum JSONKey: String {
        case identifier
        case name
        case criteriaName
        case storyName
        case price
        case quantity
    }
    
    // MARK: - Public Properties
    /**
     Unique identifier for this position.
     */
    let identifier: String
    /**
     The position name.
     */
    let name: String
    /**
     The criteria name.
     */
    let criteriaName: String
    /**
     The story name.
     */
    let storyName: String
    /**
     The position price, in dollars.
     */
    let price: NSDecimalNumber
    /**
     The position quantity.
     */
    let quantity: NSDecimalNumber
    
    // MARK: - Public Functions
    /**
     Returns an instance with random values.
     
     - Returns: The instance
     */
    static func stub(identifier: String = UUID().uuidString,
                     name:String = "Philadelphia Eagles",
                     storyName:String =  "New York Jets at Philadelphia Eagles") -> PositionModel {
        .init(identifier: identifier, name: name, criteriaName: "To win", storyName: storyName, price: NSDecimalNumber(value: Double.random(in: 0.1...99.9)), quantity: NSDecimalNumber(value: Double.random(in: 0.1...25.0)))
    }
    
    // MARK: - JSONEncodable
    func toJSON() -> JSON {
        JSON([
            JSONKey.identifier.rawValue: self.identifier,
            JSONKey.name.rawValue: self.name,
            JSONKey.criteriaName.rawValue: self.criteriaName,
            JSONKey.storyName.rawValue: self.storyName,
            JSONKey.price.rawValue: self.price.stringValue,
            JSONKey.quantity.rawValue: self.quantity.stringValue
        ])
    }
}

/**
 Extension adding `JSONDecodable` conformance.
 */
extension PositionModel: JSONDecodable {
    // MARK: - JSONDecodable
    init?(json: JSON) {
        guard let identifier = json[JSONKey.identifier.rawValue].string else {
            return nil
        }
        guard let name = json[JSONKey.name.rawValue].string else {
            return nil
        }
        guard let criteriaName = json[JSONKey.criteriaName.rawValue].string else {
            return nil
        }
        guard let storyName = json[JSONKey.storyName.rawValue].string else {
            return nil
        }
        guard let price = json[JSONKey.price.rawValue].string else {
            return nil
        }
        guard let quantity = json[JSONKey.quantity.rawValue].string else {
            return nil
        }
        
        self.identifier = identifier
        self.name = name
        self.criteriaName = criteriaName
        self.storyName = storyName
        self.price = NSDecimalNumber(string: price)
        self.quantity = NSDecimalNumber(string: quantity)
    }
}

/// Add Conformance to Hashable
extension PositionModel: Hashable { }

/// Add Conformance to Comparable for sorting
extension PositionModel: Comparable {
    
    /**
     compares positions by `identifer`
     */
    static func == (lhs:PositionModel, rhs:PositionModel) -> Bool {
        lhs.identifier == rhs.identifier
    }
    
    /**
     Sorts positions by `price` in acsending order
     */
    static func < (lhs:PositionModel, rhs:PositionModel) -> Bool {
        let lhsPrice = lhs.price as Decimal
        let rhsPrice = rhs.price as Decimal
        return lhsPrice < rhsPrice
    }
    
    /**
     Sorts positions by `price` in descending order
     */
    static func > (lhs:PositionModel, rhs:PositionModel) -> Bool {
        let lhsPrice = lhs.price as Decimal
        let rhsPrice = rhs.price as Decimal
        return lhsPrice > rhsPrice
    }
}

/// Extend array of Position Model to allow grouping by story
extension Array where Element == PositionModel {
    /**
     Groups the array of positions by `StoryName`
     
     Returns: dictionary containing all positions for each unique story name
     */
    func groupByStory() -> [String:[PositionModel]] {
        self.reduce(into: [:], { partialResult, position in
            partialResult[position.storyName, default:[]].append(position)
            partialResult[position.storyName]!.sort(by: < )
        })
    }
}
