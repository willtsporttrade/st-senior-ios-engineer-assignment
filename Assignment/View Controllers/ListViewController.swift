//
//  ListViewController.swift
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

import UIKit
import Combine

/**
 Manages the views required to display the state managed by `ListViewModel` to the user.
 */
final class ListViewController: UIViewController {
    
    // MARK: - Private Properties
    private let viewModel = DefaultApplication.shared.rootComponent.listComponent.viewModel

    private var zoomTransitionAnimator: ZoomTransitionAnimator?
    private var transitionView: UIView?
    
    private lazy var collectionView:UICollectionView = {
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(50))

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                   heightDimension: .estimated(50))
            
            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 16
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)

            let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                          heightDimension: .estimated(44))

            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize,
                                                                            elementKind:  UICollectionView.elementKindSectionHeader,
                                                                            alignment: .top)

            section.boundarySupplementaryItems = [sectionHeader]

            return section
        }


        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemGroupedBackground
        //collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var searchBar:UISearchBar = UIManager.SearchBar()
    private lazy var lblLastUpdated:UILabel = UIManager.Label(.caption2)
   
    private lazy var refreshControl = UIRefreshControl()
    private lazy var dataSource = setupDataSource()
    
    private var subscriptions = [AnyCancellable]()
    
    // MARK: - Override Functions
    
    override func loadView() {
        super.loadView()
        
        //Add views to subview
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addSubview(lblLastUpdated)
        
        //Add refresh control to collection view
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh Positions", attributes: nil)
        collectionView.refreshControl = refreshControl
        
        configureView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.viewModel.title
        self.view.backgroundColor = .backgroundViewController
        self.navigationController?.delegate = self
        
        bindViewModel()
        loadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { context in
            self.collectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }
}

// MARK: - Private Functions
extension ListViewController {
    
    private func bindViewModel() {
        searchBar.searchTextField.textPublisher
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink(receiveValue: { searchText in
                self.viewModel.searchString = searchText ?? ""
            })
            .store(in: &subscriptions)
        
        viewModel.$positions
            .sink (receiveValue: { positions in
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
                self.updateList(with: positions)
            })
            .store(in: &subscriptions)
        
        viewModel.$lastUpdatedDateString
            .assign(to: \.text, on: self.lblLastUpdated)
            .store(in: &subscriptions)
    }
    
    private func configureView() {
        
        let searchBarConstraints = [
            searchBar.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            searchBar.heightAnchor.constraint(greaterThanOrEqualToConstant: 50.0)
        ]

        let collectionViewContraints = [
            collectionView.topAnchor.constraint(equalTo: searchBar.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: lblLastUpdated.layoutMarginsGuide.topAnchor, constant: -16.0)
        ]

        let lblLastUpdatedConstraints = [
            lblLastUpdated.leadingAnchor.constraint(greaterThanOrEqualTo: view.readableContentGuide.leadingAnchor),
            lblLastUpdated.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            lblLastUpdated.bottomAnchor.constraint(equalTo: view.readableContentGuide.bottomAnchor),

            lblLastUpdated.heightAnchor.constraint(greaterThanOrEqualToConstant: 25.0)
        ]

        NSLayoutConstraint.activate(searchBarConstraints +
                                    lblLastUpdatedConstraints +
                                    collectionViewContraints)
    }
    
    @objc
    private func loadData() {
        self.viewModel.requestList { result in
            
            //handle error
            if case let .failure(error) = result {
                print(error)
            }
        }
    }
}

// MARK: - Collection View Functions

/// Extension separating private functions for Collection View Configuration
extension ListViewController {

    struct SectionModel: Hashable {
        let title: String
        let items: [PositionModel]
    }
    
    private typealias Cell = PositionCollectionViewCell
    private typealias CellRegistration = UICollectionView.CellRegistration<Cell, PositionModel>
    private typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<SectionHeaderReusableView>
    private typealias DataSource = UICollectionViewDiffableDataSource<SectionModel, PositionModel>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<SectionModel, PositionModel>
    
    private func setupCellRegistration() -> CellRegistration {
        CellRegistration { cell, indexPath, position in
            cell.name = position.name
            cell.price = NumberFormatter().formatUSCurrency(for: position.price)
       }
    }
    
    private func setupHeaderRegistration() -> HeaderRegistration {
        HeaderRegistration(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, string, indexPath in
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            supplementaryView.title = section.title
        }
    }

    private func setupDataSource() -> DataSource {
        let source = DataSource(collectionView: collectionView,
                                cellProvider: setupCellRegistration().cellProvider)
        
        source.supplementaryViewProvider = setupHeaderRegistration().headerProvider
        return source
    }
    
    private func updateList(with positions:[PositionModel], animatingDifferences: Bool = true) {
     
        var snapshot = Snapshot()
        let sections = positions.groupByStory()
                                .map { SectionModel(title: $0.key, items: $0.value) }
                                .sorted(by: <)
        
        snapshot.appendSections(sections)
        sections.forEach { snapshot.appendItems($0.items, toSection: $0) }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

/// Add Conformance to Comparable for sorting
extension ListViewController.SectionModel :Comparable {
    static func < (lhs:ListViewController.SectionModel, rhs:ListViewController.SectionModel) -> Bool {
        return lhs.title < rhs.title
    }
}

// MARK: - Collection View Delegate Functions
extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let position = dataSource.itemIdentifier(for: indexPath),
        let cell = collectionView.cellForItem(at: indexPath) as? PositionCollectionViewCell else { return }
        transitionView = cell.contentView
        let detailView = DetailViewController(position: position)
        self.navigationController?.pushViewController(detailView, animated: true)
    }
}

// MARK: - Navigation Controller Delegate
extension ListViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .push {
            // Pass the frame to the transition animator.
            guard let transitionThumbnail = transitionView,
                  let transitionThumbnailSuperview = transitionThumbnail.superview else { return nil }
            
            zoomTransitionAnimator = ZoomTransitionAnimator()
            zoomTransitionAnimator?.frame = transitionThumbnailSuperview.convert(transitionThumbnail.frame, to: nil)
        }
        
        zoomTransitionAnimator?.operation = operation
        return zoomTransitionAnimator
    }
}




