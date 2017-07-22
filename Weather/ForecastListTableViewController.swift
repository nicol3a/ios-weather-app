//
//  ForecastListTableViewController.swift
//  Weather
//
//  Created by Nicolas Bichon on 04/08/16.
//  Copyright © 2016 Nicolas Bichon. All rights reserved.
//

import UIKit

class ForecastListTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    lazy var viewModel: ForecastListViewModel = {
        let viewModel = ForecastListViewModel()
        viewModel.delegate = self
        return viewModel
    }()
    
    fileprivate var fetchedResultsControllerDelegate: FetchedResultsControllerDelegate!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupFetchResultsController()
        viewModel.fetchForecastList()
        viewModel.downloadForecastList()
        self.title = viewModel.title()
    }
    
    // MARK: - Setup
    
    fileprivate func setupTableView() {
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    fileprivate func setupFetchResultsController() {
        fetchedResultsControllerDelegate = FetchedResultsControllerDelegate()
        fetchedResultsControllerDelegate.tableView = tableView
        fetchedResultsControllerDelegate.updateCellBlock = { indexPath in
            if let indexPath = indexPath, let cell = self.tableView.cellForRow(at: indexPath as IndexPath) as? ForecastTableViewCell {
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
        viewModel.downloadForecastList() {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath) as! ForecastTableViewCell
        cell.viewModel = viewModel.itemAtIndex(indexPath.row)
        return cell
    }
}

// MARK: - ForecastListViewModelDelegate
extension ForecastListTableViewController: ForecastListViewModelDelegate {
    func forecastListViewModel(_ viewModel: ForecastListViewModel, didUpdateForecastListWithState state: State) {
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
