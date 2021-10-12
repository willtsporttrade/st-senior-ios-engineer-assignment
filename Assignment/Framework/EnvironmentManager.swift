//
//  EnvironmentManager.swift
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
 Manages the current execution environment.
 */
final class EnvironmentManager {
    // MARK: - Public Types
    /**
     Represents the execution environment.
     */
    enum Environment {
        /**
         The testing environment, **all** network responses are stubbed.
         */
        case testing
        
        // MARK: - Public Properties
        /**
         Returns the stub behavior to use.
         */
        var stubBehavior: StubBehavior {
            switch self {
            case .testing:
                return .immediate
            }
        }
    }
    
    // MARK: - Public Properties
    /**
     The current environment.
     */
    let environment: Environment
    
    // MARK: - Initializers
    /**
     Creates an instance with the provided environment.
     
     - Parameter environment: The environment to use
     - Returns: The instance
     */
    init(environment: Environment) {
        self.environment = environment
    }
}
