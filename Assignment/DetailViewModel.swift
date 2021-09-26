//
//  DetailViewModel.swift
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

import NeedleFoundation

/**
 Describes the dependencies required for `DetailViewModelComponent`.
 */
protocol DetailViewModelDependency: Dependency {
    // MARK: - Public Properties
    /**
     The network manager to inject.
     */
    var networkManager: NetworkManager { get }
}

/**
 Creates `DetailViewModel` instances.
 */
final class DetailViewModelComponent: Component<DetailViewModelDependency> {
    // MARK: - Public Functions
    /**
     Returns a view model instance.
     
     - Parameter position: The represented position
     - Returns: The instance
     */
    func viewModel(position: PositionModel) -> DetailViewModel {
        .init(position: position, networkManager: self.networkManager)
    }
}

final class DetailViewModel {
    // MARK: - Public Properties
    /**
     Returns the title, suitable for display to the user.
     */
    var title: String {
        self.position.name
    }
    
    // MARK: - Private Properties
    private let position: PositionModel
    private let networkManager: NetworkManager
    
    // MARK: - Initializers
    /**
     Creates an instance with the provided parameters.
     
     - Parameter position: The represented position
     - Parameter networkManager: The network manager to use
     - Returns: The instance
     */
    init(position: PositionModel, networkManager: NetworkManager) {
        self.position = position
        self.networkManager = networkManager
    }
}
