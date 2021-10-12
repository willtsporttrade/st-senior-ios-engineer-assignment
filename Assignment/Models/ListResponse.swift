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
        .init(positions: (1...20).map { _ in
            let story = TestStories(rawValue: Int.random(in: 1...2))!
            var name:TestNames = .Eagles
            switch story {
            case.JetsEagles:
                name = TestNames(rawValue: Int.random(in: 0...1))!
            case .Seahawks49ers:
                name = TestNames(rawValue: Int.random(in: 2...3))!
            }
            
            return .stub(name:name.description, storyName: story.description)
        })
    }
    
    // MARK: - JSONEncodable
    func toJSON() -> JSON {
        JSON(self.positions.map {
            $0.toJSON()
        })
    }
}


// MARK - Extended List Response to be able to expand on the stubbed data
fileprivate extension ListResponse {
    enum TestStories:Int {
        case JetsEagles = 1
        case Seahawks49ers = 2
    }
    
    enum TestNames:Int {
        case Jets = 0
        case Eagles = 1
        case Seahawks = 2
        case SanFran = 3
    }
}

extension ListResponse.TestStories:CustomStringConvertible {
    var description: String {
        switch self {
        case .JetsEagles:
            return "New York Jets at Philadelphia Eagles"
        case .Seahawks49ers:
            return "Settle Seahawks at San Fransico 49ers"
        }
    }
}

extension ListResponse.TestNames:CustomStringConvertible {
    var description: String {
        switch self {
        case .Jets:
            return "New York Jets"
        case .Eagles:
            return "Philadelphia Eagles"
        case .Seahawks:
            return "Settle Seahawks"
        case .SanFran:
            return "San Fransico 49ers"
        }
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
