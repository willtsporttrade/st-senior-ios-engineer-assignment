//
//  DetailViewController.swift
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
import Charts
import Combine


/**
 Manages the views required to display the state managed by `DetailViewModel` to the user.
 */

final class DetailViewController: UIViewController {
    
    // MARK: - Private Properties
    private let viewModel: DetailViewModel
    
    private lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var chtChart: LineChartView = {
        let chart = LineChartView(frame: .zero)
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()
    
    private lazy var lblStoryName: UILabel = UIManager.Label(.largeTitle)
    private lazy var infoCard = UIView(frame: .zero)
    private lazy var lblCriteria = UIManager.Label(.body)
    private lazy var lblName: UILabel = UIManager.Label(.body)
    private lazy var lblQuantity: UILabel = UIManager.Label(.caption1)
    private lazy var lblPrice: UILabel = UIManager.Label(.caption1)
    
    private var priceChartData = [ChartDataEntry]()
    private var quantityChartData = [ChartDataEntry]()
    
    private var subscriptions = [AnyCancellable]()
    
    // MARK: - Initializers
    /**
     Creates an instance to display the provided position.
     
     - Parameter position: The position to display
     - Returns: The instance
     */
    init(position: PositionModel) {
        self.viewModel = DefaultApplication.shared.rootComponent.detailComponent.viewModel(position: position)
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not available")
    }
    
    
    // MARK: - Override Functions
    
    override func loadView() {
        super.loadView()
        configureView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
}

// MARK: - Private Functions - Configure View

extension DetailViewController {
    
    private func configureView() {
        
        self.view.backgroundColor = .backgroundViewController
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            view.addSubview(lblStoryName)
            view.addSubview(infoCard)
            view.addSubview(chtChart)
            
            lblStoryName.anchor(top: view.layoutMarginsGuide.topAnchor,
                                leading: view.layoutMarginsGuide.leadingAnchor,
                                trailing: view.layoutMarginsGuide.trailingAnchor)
            
            lblStoryName.setMinSize(height: 50.0)
            
            infoCard.anchor(top:lblStoryName.bottomAnchor, paddingTop: 16.0,
                            leading: view.layoutMarginsGuide.leadingAnchor, paddingLeading: 16.0,
                            trailing: view.layoutMarginsGuide.trailingAnchor, paddingtrailing: -16.0)
            
            setupInfoCard()
            
            chtChart.anchor(top:infoCard.bottomAnchor, paddingTop: 16.0,
                            bottom: view.layoutMarginsGuide.bottomAnchor, paddingBottom: 16.0,
                            leading: view.layoutMarginsGuide.leadingAnchor, paddingLeading: 16.0,
                            trailing: view.layoutMarginsGuide.trailingAnchor, paddingtrailing: -16.0)
        }
        else {
            
            view.addSubview(lblStoryName)
            view.addSubview(scrollView)
            
            scrollView.addSubview(infoCard)
            scrollView.addSubview(chtChart)

            lblStoryName.anchor(top: view.layoutMarginsGuide.topAnchor,
                                leading: view.layoutMarginsGuide.leadingAnchor,
                                trailing: view.layoutMarginsGuide.trailingAnchor)
            
            lblStoryName.setMinSize(height: 50.0)
            
            scrollView.anchor(top: lblStoryName.bottomAnchor, paddingTop: 16.0,
                              bottom: view.layoutMarginsGuide.bottomAnchor,
                              leading: view.layoutMarginsGuide.leadingAnchor,
                              trailing: view.layoutMarginsGuide.trailingAnchor)
            
            infoCard.anchor(top:scrollView.topAnchor, paddingTop: 16.0,
                            leading: view.layoutMarginsGuide.leadingAnchor,
                            trailing: view.layoutMarginsGuide.trailingAnchor)
            
            setupInfoCard()

            chtChart.anchor(top:infoCard.bottomAnchor, paddingTop: 16.0,
                            leading: view.layoutMarginsGuide.leadingAnchor,
                            trailing: view.layoutMarginsGuide.trailingAnchor)
            
            chtChart.setSize(height: view.frame.width)
            
            NSLayoutConstraint.activate([
                scrollView.contentLayoutGuide.topAnchor.constraint(equalTo: scrollView.topAnchor),
                scrollView.contentLayoutGuide.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
                scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: chtChart.bottomAnchor),
                scrollView.contentLayoutGuide.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
            ])
            
        }
    }
    
    private func setupInfoCard() {
        
        let lblCriteriaTitle: UILabel = {
            let label =  UIManager.Label(.title3, bold: true)
            label.text = LocalizedString.criteria
            return label
        }()
        
        let lblNameTitle: UILabel = {
            let label =  UIManager.Label(.title3, bold: true)
            label.text = LocalizedString.positionName
            return label
        }()

        let lblPriceTitle: UILabel = {
            let label =  UIManager.Label(.title3, bold: true)
            label.text = LocalizedString.price
            return label
        }()
        
        let lblQuantityTitle:UILabel = {
           let label = UIManager.Label(.title3, bold: true)
            label.text = LocalizedString.quantity
            return label
        }()
        
        infoCard.layer.borderWidth = 1.0
        infoCard.layer.borderColor = UIColor.lightGray.cgColor
        infoCard.layer.cornerRadius = 8.0
        
        infoCard.addSubview(lblName)
        infoCard.addSubview(lblQuantity)
        infoCard.addSubview(lblPrice)
        infoCard.addSubview(lblCriteria)
        
        infoCard.addSubview(lblNameTitle)
        infoCard.addSubview(lblCriteriaTitle)
        infoCard.addSubview(lblQuantityTitle)
        infoCard.addSubview(lblPriceTitle)
        
  
        self.setConstaints(forTitle: lblNameTitle,
                           andValue: lblName,
                           relativeTo: infoCard.layoutMarginsGuide.topAnchor)
        
        self.setConstaints(forTitle: lblCriteriaTitle,
                           andValue: lblCriteria,
                           relativeTo: UIDevice.current.userInterfaceIdiom == .pad ? lblNameTitle.layoutMarginsGuide.bottomAnchor :
                                                                                     lblName.layoutMarginsGuide.bottomAnchor)

        self.setConstaints(forTitle: lblQuantityTitle,
                           andValue: lblQuantity,
                           relativeTo: UIDevice.current.userInterfaceIdiom == .pad ? lblCriteriaTitle.layoutMarginsGuide.bottomAnchor :
                                                                                     lblCriteria.layoutMarginsGuide.bottomAnchor)
        
        self.setConstaints(forTitle: lblPriceTitle,
                           andValue: lblPrice,
                           relativeTo: UIDevice.current.userInterfaceIdiom == .pad ? lblQuantityTitle.layoutMarginsGuide.bottomAnchor :
                                                                                     lblQuantity.layoutMarginsGuide.bottomAnchor)
        
        NSLayoutConstraint.activate([lblPrice.bottomAnchor.constraint(equalTo: infoCard.layoutMarginsGuide.bottomAnchor, constant: -16.0)])
    }
    
    private func setConstaints(forTitle lblTitle:UILabel, andValue lblValue:UILabel, relativeTo topAnchor: NSLayoutYAxisAnchor) {
        
        NSLayoutConstraint.activate([
            lblTitle.topAnchor.constraint(equalTo: topAnchor),
            lblTitle.leadingAnchor.constraint(equalTo: infoCard.layoutMarginsGuide.leadingAnchor),
            lblTitle.heightAnchor.constraint(greaterThanOrEqualToConstant: 50.0),
        ])
        
        if UIDevice.current.userInterfaceIdiom == .pad {
              NSLayoutConstraint.activate([
                lblTitle.widthAnchor.constraint(equalTo: infoCard.widthAnchor, multiplier: 0.5),
            ])
        } else {
              NSLayoutConstraint.activate([
                lblTitle.trailingAnchor.constraint(equalTo: infoCard.layoutMarginsGuide.trailingAnchor),
              ])
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
              NSLayoutConstraint.activate([
                lblValue.topAnchor.constraint(equalTo: lblTitle.topAnchor),
                lblValue.leadingAnchor.constraint(equalTo: lblTitle.layoutMarginsGuide.trailingAnchor, constant: 16.0),
            ])
        } else {
              NSLayoutConstraint.activate([
                lblValue.topAnchor.constraint(equalTo: lblTitle.layoutMarginsGuide.bottomAnchor),
                lblValue.leadingAnchor.constraint(equalTo: lblTitle.leadingAnchor),
              ])
        }
        
        NSLayoutConstraint.activate([
            lblValue.trailingAnchor.constraint(equalTo: infoCard.layoutMarginsGuide.trailingAnchor),
            lblValue.heightAnchor.constraint(greaterThanOrEqualToConstant: 50.0)
        ])
        
    }
}

// MARK: - Private Functions - Bind View Model

extension DetailViewController {
    
    private func bindViewModel() {
         // Properties that can be assigned using default assign method
         subscriptions = [
             viewModel.$story.assign(to: \.text, on: lblStoryName),
             viewModel.$title.assign(to: \.text, on: lblName),
             viewModel.$price.assign(to: \.text, on: lblPrice),
             viewModel.$quantity.assign(to: \.text, on: lblQuantity),
             viewModel.$criteria.assign(to: \.text, on: lblCriteria)
         ]
        
        viewModel.$chartData
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] chartData in
                self?.priceChartData.append(ChartDataEntry(x: chartData.interval, y: chartData.price))
                self?.quantityChartData.append(ChartDataEntry(x: chartData.interval, y: chartData.quantity))
                self?.configureChart()
            })
            .store(in: &subscriptions)
    }
    
    private func configureChart() {
        
        let priceLine = LineChartDataSet(entries: self.priceChartData, label: "Price")
        priceLine.colors = [.green]
        priceLine.drawCircleHoleEnabled = false
        priceLine.drawCirclesEnabled = false
        
        let quantityLine = LineChartDataSet(entries: self.quantityChartData, label: "Quantity")
        quantityLine.colors = [.red]
        quantityLine.drawCircleHoleEnabled = false
        quantityLine.drawCirclesEnabled = false
        
        chtChart.data = LineChartData(dataSets: [priceLine, quantityLine])
    }
}
