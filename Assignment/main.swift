//
//  main.swift
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

final class RootComponent: BootstrapComponent {
    // MARK: - Public Properties
    var environmentManager: EnvironmentManager {
        self.shared {
            EnvironmentManager(environment: self.environment)
        }
    }
    
    var networkManager: NetworkManager {
        self.shared {
            NetworkManager(environmentManager: self.environmentManager)
        }
    }
    
    // MARK: -
    var listComponent: ListViewModelComponent {
        ListViewModelComponent(parent: self)
    }
    
    var detailComponent: DetailViewModelComponent {
        DetailViewModelComponent(parent: self)
    }
    
    // MARK: - Private Properties
    private let environment: EnvironmentManager.Environment
    
    // MARK: - Initializers
    init(environment: EnvironmentManager.Environment) {
        self.environment = environment
        
        super.init()
    }
}

final class DefaultApplication: UIApplication {
    // MARK: - Public Properties
    let rootComponent = RootComponent(environment: .testing)
    
    // MARK: - Override Properties
    override class var shared: DefaultApplication {
        // swiftlint:disable force_cast
        super.shared as! DefaultApplication
    }
}

// needle
registerProviderFactories()

// launch the app
UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, NSStringFromClass(DefaultApplication.self), NSStringFromClass(AppDelegate.self))
