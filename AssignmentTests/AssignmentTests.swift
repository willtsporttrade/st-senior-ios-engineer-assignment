//
//  AssignmentTests.swift
//  AssignmentTests
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

import Nimble
import Quick
import XCTest
@testable import Assignment

final class AssignmentTests: QuickSpec {
    // MARK: - Override Functions
    override func spec() {
        describe("AssignmentTests") {
            var rootComponent: RootComponent!
            
            beforeEach {
                rootComponent = RootComponent(environment: .testing)
            }
            
            context("Function name") {
                it("Test expectation") {
                    
                }
            }
        }
    }
}
