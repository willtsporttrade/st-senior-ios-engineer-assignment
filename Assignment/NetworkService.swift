//
//  NetworkService.swift
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

import Moya

/**
 Represents individual endpoints.
 */
enum NetworkService: TargetType {
    /**
     Returns a list of positions.
     */
    case list
    /**
     Returns the detail for a single position.
     */
    case detail(identifier: String)
    
    // MARK: - TargetType
    var baseURL: URL {
        URL(string: "https://getsporttrade.com/")!
    }
    
    var path: String {
        switch self {
        case .list:
            return "positions"
        case .detail(let identifier):
            return "positions/\(identifier)"
        }
    }
    
    var method: Method {
        .get
    }
    
    var sampleData: Data {
        switch self {
        case .list:
            return try! ListResponse.stub().toJSON().rawData()
        case .detail:
            return Data()
        }
    }
    
    var task: Task {
        .requestPlain
    }
    
    var validationType: ValidationType {
        .successCodes
    }
    
    var headers: [String: String]? {
        nil
    }
}
