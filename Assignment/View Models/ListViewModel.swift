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
    var title: String = LocalizedString.positions

    // MARK: Input Properties
    
    /**
     Used to set a query string for searching the list of posions.
     
     - Note: This property also contains a property wrapped publisher that can
             is subsribed to within the View Model that will automatically perform
             the search and update the `positions` property with the results
     */
    @Published
    var searchString = ""
    
    // MARK: Input Properties
    
    /**
     Returns the last updated date string, suitable for display to the user.
     
     - Note: This property also contains a property wrapped publisher that can
             be subsribed to using `$lastUpdatedDateString`
     */
    @Published
    private(set) var lastUpdatedDateString:String?

    /**
     Returns the array of positions for display to the user.
     
     - Note: This property also contains a property wrapped publisher that can
             be subsribed to using `$positions`
     */
    @Published
    private(set) var positions:[PositionModel] = []


    // MARK: - Private Properties
    private let networkManager: NetworkManager
    private let combineManager: CombineManager
    private var cancellables = Set<AnyCancellable>()
    
    private var listResponse:ListResponse?
    
    private lazy var dateFormatter:DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("E, d h:mm:ss")
        return dateFormatter
    }()
    

    // MARK: - Initializers
    /**
     Creates an instance with the provided parameters.
     
     - Parameter networkManager: The network manager to use
     - Returns: The instance
     */
    init(networkManager: NetworkManager, combineManager: CombineManager) {
        self.networkManager = networkManager
        self.combineManager = combineManager
        
        $searchString
            .removeDuplicates()
            .sink(receiveValue: { queryString in
                self.searchPositions(with: queryString)
            })
            .store(in: &cancellables)
    }
    
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
                self.listResponse = $0
                self.lastUpdatedDateString = "\(LocalizedString.lastUpdatedTitle) \(self.dateFormatter.string(from: Date()))"
                self.searchPositions(with: self.searchString)
                completion?(.success($0))
            }
            .store(in: &self.cancellables)
    }
}

// MARK: - Private Functions

extension ListViewModel {
    private func searchPositions(with searchText:String) {
        guard let positions = self.listResponse?.positions else { return }
        self.positions = searchText.isEmpty ? positions : positions.filter{ $0.name.contains(searchText) }
    }
}
