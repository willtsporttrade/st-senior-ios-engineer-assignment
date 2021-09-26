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
    let identifier: String
    let name: String
    let criteriaName: String
    let storyName: String
    let price: NSDecimalNumber
    let quantity: NSDecimalNumber
    
    // MARK: - Public Functions
    static func stub() -> PositionModel {
        .init(identifier: UUID().uuidString, name: "Name", criteriaName: "Criteria name", storyName: "Story name", price: NSDecimalNumber(value: Double.random(in: 0.1...99.9)), quantity: NSDecimalNumber(value: Double.random(in: 0.1...25.0)))
    }
    
    // MARK: - JSONEncodable
    func toJSON() -> JSON {
        JSON([
            JSONKey.name.rawValue: self.name,
            JSONKey.criteriaName.rawValue: self.criteriaName,
            JSONKey.storyName.rawValue: self.storyName,
            JSONKey.price.rawValue: self.price.stringValue,
            JSONKey.quantity.rawValue: self.quantity.stringValue
        ])
    }
}

extension PositionModel: JSONDecodable {
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
