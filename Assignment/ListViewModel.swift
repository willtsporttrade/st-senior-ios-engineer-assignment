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

protocol ListViewModelDependency: Dependency {
    // MARK: - Public Properties
    var networkManager: NetworkManager { get }
}

final class ListViewModelComponent: Component<ListViewModelDependency> {
    // MARK: - Public Properties
    var viewModel: ListViewModel {
        .init(networkManager: self.networkManager)
    }
}

final class ListViewModel {
    // MARK: - Public Properties
    var title: String {
        NSLocalizedString("list.title", value: "List", comment: "List title")
    }
    
    // MARK: - Private Properties
    private let networkManager: NetworkManager
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Public Functions
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
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
}
