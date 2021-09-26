//
//  ListViewModel.swift
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
import NeedleFoundation
import os.log

/**
 Describes the dependencies required for `ListViewModelComponent`.
 */
protocol ListViewModelDependency: Dependency {
    // MARK: - Public Properties
    /**
     The network manager to inject.
     */
    var networkManager: NetworkManager { get }
    var combineManager: CombineManager { get }
}

/**
 Creates `ListViewModel` instances.
 */
final class ListViewModelComponent: Component<ListViewModelDependency> {
    // MARK: - Public Properties
    /**
     Returns a view model instance.
     */
    var viewModel: ListViewModel {
        .init(networkManager: self.networkManager, combineManager: self.combineManager)
    }
}

/**
 Manages the state required for `ListViewController`.
 */
final class ListViewModel {
    // MARK: - Public Properties
    /**
     Returns the title, suitable for display to the user.
     */
    var title: String {
        NSLocalizedString("list.title", value: "Positions", comment: "List title")
    }
    
    // MARK: - Private Properties
    private let networkManager: NetworkManager
    private let combineManager: CombineManager
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Public Functions
    /**
     Request the list of positions and invoke the provided completion block.
     
     - Parameter completion: The completion to invoke on the main thread when the request has finished
     */
    func requestList(completion: ((Result<ListResponse, Error>) -> Void)? = nil) {
        self.networkManager.list()
            .receive(on: DispatchQueue.main)
            .sink {
                switch $0 {
                case .failure(let error):
                    completion?(.failure(error))
                default:
                    break
                }
            } receiveValue: {
                completion?(.success($0))
            }
            .store(in: &self.cancellables)
    }
    
    // MARK: - Initializers
    /**
     Creates an instance with the provided parameters.
     
     - Parameter networkManager: The network manager to use
     - Returns: The instance
     */
    init(networkManager: NetworkManager, combineManager: CombineManager) {
        self.networkManager = networkManager
        self.combineManager = combineManager
    }
}
