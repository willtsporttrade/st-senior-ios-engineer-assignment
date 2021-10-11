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
import Combine

/**
 Describes the dependencies required for `DetailViewModelComponent`.
 */
protocol DetailViewModelDependency: Dependency {
    // MARK: - Public Properties
    /**
     The network manager to inject.
     */
    var networkManager: NetworkManager { get }
    /**
     The combine manager to inject.
     */
    var combineManager: CombineManager { get }
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
        .init(position: position,
              networkManager: self.networkManager,
              combineManager: self.combineManager)
    }
}

final class DetailViewModel {
    // MARK: - Public Properties

    /**
     Returns the title for display to the user.
     
     - Note: This property also contains a property wrapped publisher that can
             be subsribed to using `$title`
     */
    @Published
    private(set) var title:String?
    

    /**
     Returns the position story name for display to the user.
     
     - Note: This property also contains a property wrapped publisher that can
             be subsribed to using `$story`
     */
    @Published
    private(set) var story: String?

    /**
     Returns the position quantity for display to the user.
     
     - Note: This property also contains a property wrapped publisher that can
             be subsribed to using `$story`
     */
    @Published
    private(set) var quantity: String?
    
    /**
     Returns the position price for display to the user.
     
     - Note: This property also contains a property wrapped publisher that can
             be subsribed to using `$price`
     */
    @Published
    private(set) var price: String?
   
    /**
     Returns the position criteria for display to the user.
     
     - Note: This property also contains a property wrapped publisher that can
             be subsribed to using `$criteria`
     */
    @Published
    private(set) var criteria: String?

    /**
     Returns the date of the last update received for display to the user.
     
     - Note: This property also contains a property wrapped publisher that can
             be subsribed to using `$lastedUpdatedDate`
     */
    @Published
    private(set) var lastedUpdatedDate: Date
    
    /**
     Returns the data used to populate the chart as a truple containing
       the `quantity` and `price` of the position as well as a `interval`
       which desinates the change over time
     
     - Note: This property also contains a property wrapped publisher that can
             be subsribed to using `$chartData`
     */
    @Published
    private(set) var chartData: (quantity:Double, price:Double, interval:Double)?
    
    // MARK: - Private Properties
    
    private var position: PositionModel
    private let networkManager: NetworkManager
    private let combineManager: CombineManager
    private let initialDate:Date = Date()
    
    private var cancellables = Set<AnyCancellable>()
    
    
    // MARK: - Initializers
    
    /**
     Creates an instance with the provided parameters.
     
     - Parameter position: The represented position
     - Parameter networkManager: The network manager to use
     - Returns: The instance
     */
    init(position: PositionModel, networkManager: NetworkManager, combineManager: CombineManager) {
        self.position = position
        self.networkManager = networkManager
        self.combineManager = combineManager
        self.lastedUpdatedDate = initialDate
        
        loadData()
        updateData()
    }
    
    deinit {
        cancellables.forEach({ $0.cancel() })
        print("detail View Closed")
    }
    
}

extension DetailViewModel {
    private func loadData() {
        combineManager.position(identifier: position.identifier)
            .sink(receiveValue: {
                self.position = $0
                self.lastedUpdatedDate = Date()
                self.updateData()
            })
            .store(in: &cancellables)
    }
    
    private func updateData () {
        self.title = position.name
        self.story = position.storyName
        self.quantity = NumberFormatter().formatToMax4Decimal(for: position.quantity)
        self.price = NumberFormatter().formatUSCurrency(for: position.price)
        self.criteria =  position.criteriaName
        let updateInterval = self.lastedUpdatedDate.timeIntervalSince(self.initialDate)
        self.chartData = (quantity:Double(truncating: position.quantity), price:Double(truncating: position.price), updateInterval)
    }
    
}
