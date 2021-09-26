//
//  ListResponse.swift
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
 Represents the network response for the `NetworkService.list` endpoint.
 */
struct ListResponse: JSONEncodable {
    // MARK: - Public Properties
    /**
     The list of positions.
     */
    let positions: [PositionModel]
    
    // MARK: - Public Functions
    /**
     Returns an instance with random values.
     */
    static func stub() -> ListResponse {
        .init(positions: (1...10).map { _ in
            .stub()
        })
    }
    
    // MARK: - JSONEncodable
    func toJSON() -> JSON {
        JSON(self.positions.map {
            $0.toJSON()
        })
    }
}

/**
 Extension adding `JSONDecodable` conformance.
 */
extension ListResponse: JSONDecodable {
    // MARK: - JSONDecodable
    init?(json: JSON) {
        guard json.type == .array else {
            return nil
        }
        
        self.positions = json.compactMap { _, json in
            PositionModel(json: json)
        }
    }
}
