//
//  NetworkManager.swift
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

final class NetworkManager {
    // MARK: - Private Properties
    private let environmentManager: EnvironmentManager
    private let networkProvider: MoyaProvider<NetworkService>
    private let queue = DispatchQueue(label: "\(Bundle.main.bundleIdentifier!).\(String(describing: NetworkManager.self))", qos: .userInitiated)
    
    // MARK: - Public Functions
    func list() -> AnyPublisher<ListResponse, MoyaError> {
        self.requestPublisher(target: .list)
            .compactMapJSONDecodable(ListResponse.self)
    }
    
    // MARK: - Private Functions
    private func requestPublisher(target: NetworkService) -> AnyPublisher<Response, MoyaError> {
        self.networkProvider.requestPublisher(target, callbackQueue: self.queue)
    }
    
    // MARK: - Initializers
    init(environmentManager: EnvironmentManager) {
        self.environmentManager = environmentManager
        self.networkProvider = MoyaProvider(stubClosure: { _ in
            environmentManager.environment.stubBehavior
        }, callbackQueue: self.queue, session: Session(startRequestsImmediately: false), plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    }
}
