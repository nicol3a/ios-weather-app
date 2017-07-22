//
//  WeatherListTableViewController.swift
//  Weather
//
//  Created by Nicolas Bichon on 04/08/16.
//  Copyright © 2016 Nicolas Bichon. All rights reserved.
//

import UIKit

class WeatherListTableViewController: UITableViewController {

    // MARK: - Properties
    
    lazy var viewModel: WeatherListViewModel = {
        let viewModel = WeatherListViewModel()
        viewModel.delegate = self
        return viewModel
    }()
    
    fileprivate var activityIndicatorView = UIActivityIndicatorView()
    fileprivate var fetchedResultsControllerDelegate: FetchedResultsControllerDelegate!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotifications()
        setupTableView()
        setupFetchResultsController()
        viewModel.fetchWeatherList()
        viewModel.downloadWeatherList()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup
    
    fileprivate func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: .applicationDidBecomeActiveNotification,
            name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil
        )
    }
    
    fileprivate func setupTableView() {
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    fileprivate func setupFetchResultsController() {
        fetchedResultsControllerDelegate = FetchedResultsControllerDelegate()
        fetchedResultsControllerDelegate.tableView = tableView
        fetchedResultsControllerDelegate.updateCellBlock = { indexPath in
            if let indexPath = indexPath, let cell = self.tableView.cellForRow(at: indexPath as IndexPath) as? WeatherTableViewCell {
                cell.viewModel = self.viewModel.itemAtIndex(indexPath.row)
            }
        }
        viewModel.fetchedResultsController.delegate = fetchedResultsControllerDelegate
    }
    
    // MARK: - Actions
    
    /**
     Refresh the data. Called by the `UIRefreshControl`.
     
     - parameter sender: The sender.
     */
    @IBAction func refresh(_ sender: AnyObject?) {
        viewModel.downloadWeatherList {
            runOnMain {
                self.refreshControl?.endRefreshing()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! WeatherTableViewCell
        cell.viewModel = viewModel.itemAtIndex(indexPath.row)
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? ForecastListTableViewController,
            let cell = sender as? WeatherTableViewCell,
            let cellViewModel = cell.viewModel {
            viewController.viewModel.managedObjectContext = cellViewModel.managedObjectContext
            viewController.viewModel.city = cellViewModel.weather.city
        }
    }
    
    // MARK: - Notifications
    
    func applicationDidBecomeActiveNotification(_ notification: Notification) {
        viewModel.downloadWeatherList()
    }
}

// MARK: - WeatherListViewModelDelegate
extension WeatherListTableViewController: WeatherListViewModelDelegate {
    func weatherListViewModel(_ viewModel: WeatherListViewModel, didUpdateWeatherListWithState state: State) {
        guard case .failed(let error) = state else {
            return
        }
        
        let alertController = AlertControllerUtil.create(
            NSLocalizedString("Error", comment: ""),
            message: error.description()
        )
        
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Selectors
private extension Selector {
    static let applicationDidBecomeActiveNotification = #selector(WeatherListTableViewController.applicationDidBecomeActiveNotification(_:))
}
