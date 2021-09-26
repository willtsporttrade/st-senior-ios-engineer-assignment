//
//  Publisher+Extensions.swift
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

import Combine
import Moya
import os.log
import SwiftyJSON

/**
 Extension containing `Publisher` convenience functions.
 */
extension Publisher where Output == Response, Failure == MoyaError {
    // MARK: - Public Functions
    /**
     Returns a publisher that will attempt to decode the response data into a `JSON` instance, then initialize an instance of the provided class with that data.
     
     - Parameter type: The class conforming to JSONDecodable
     - Returns: The publisher
     */
    func compactMapJSONDecodable<T: JSONDecodable>(_ type: T.Type) -> AnyPublisher<T, MoyaError> {
        self.compactMap {
            guard let json = try? JSON(data: $0.data) else {
                return nil
            }
            guard let retval = T(json: json) else {
                os_log(.error, "Cannot convert %@ to %@!", String(describing: json), String(describing: type))
                
                return nil
            }
            
            return retval
        }
        .eraseToAnyPublisher()
    }
}
