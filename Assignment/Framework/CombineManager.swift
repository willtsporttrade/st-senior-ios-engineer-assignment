//
//  CombineManager.swift
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
import Foundation

/**
 Contains functions that simulate updates on positions.
 */
final class CombineManager {
    // MARK: - Public Functions
    /**
     Returns a publisher that sends an updated `PositionModel` on an interval and never fails.
     
     - Parameter identifier: The identifier of the position
     - Returns: The publisher
     */
    func position(identifier: String) -> AnyPublisher<PositionModel, Never> {
        Timer.publish(every: 5.0, tolerance: nil, on: .main, in: .default, options: nil)
            .autoconnect()
            .map { _ in
                PositionModel.stub(identifier: identifier)
            }
            .eraseToAnyPublisher()
    }
}
