//
//  WeatherListViewModel.swift
//  Weather
//
//  Created by Nicolas Bichon on 05/08/16.
//  Copyright © 2016 Nicolas Bichon. All rights reserved.
//

import Foundation
import CoreData

protocol WeatherListViewModelDelegate: class {
    func weatherListViewModel(_ viewModel: WeatherListViewModel, didUpdateWeatherListWithState state: State)
}

class WeatherListViewModel {
    var managedObjectContext: NSManagedObjectContext!
    
    fileprivate(set) var state = State.initial {
        didSet {
            switch self.state {
            case .initial:
                return
            case .loading:
                NetworkIndicator.startNetworkActivity()
            default:
                NetworkIndicator.stopNetworkActivity()
            }
        }
    }
    
    /// Loading all current weathers (not forecast) ordered by closest to the farthest.
    lazy var fetchedResultsController: NSFetchedResultsController<Weather> = {
        let fetchRequest = NSFetchRequest<Weather>(entityName: "Weather")
        fetchRequest.predicate = NSPredicate(format: "isForecast == 0")
        let positionSort = NSSortDescriptor(key: "city.position", ascending: true)
        fetchRequest.sortDescriptors = [positionSort]
        
        let fetchedResultsController = NSFetchedResultsController<Weather>(
            fetchRequest: fetchRequest,
            managedObjectContext: self.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        return fetchedResultsController
    }()
    
    weak var delegate: WeatherListViewModelDelegate?
    
    // MARK: - Downloading
    
    func downloadWeatherList(_ completion: (() -> Void)? = nil) {
        state = .loading

        WeatherService(managedObjectContext: managedObjectContext).downloadWeatherListByCoordinates(
            Constants.City.Brussels.latitude,
            longitude: Constants.City.Brussels.longitude,
            count: Constants.City.numberOfItems,
            success: { response in
                completion?()
                self.finishWithSuccess()
            }, failure: { error in
                completion?()
                self.failWithError(error)
            }
        )
    }
    
    fileprivate func finishWithSuccess() {
        state = .completed
        delegate?.weatherListViewModel(self, didUpdateWeatherListWithState: state)
    }

    fileprivate func failWithError(_ error: Error) {
        state = .failed(error)
        delegate?.weatherListViewModel(self, didUpdateWeatherListWithState: state)
    }
    
    // MARK: - Fetching
    
    func fetchWeatherList() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
        }
    }
    
    /**
     Returns the view model for the cell at an index.
     
     - returns: An `WeatherCellViewModel` object.
     */
    func itemAtIndex(_ index: Int) -> WeatherCellViewModel? {
        if numberOfItems() == 0 || index >= numberOfItems() {
            return nil
        }
        
        let weather = fetchedResultsController.object(at: IndexPath(row: index, section: 0))
        
        return WeatherCellViewModel(weather: weather, managedObjectContext: managedObjectContext)
    }
    
    /**
     Returns the number of weathers.
     
     - returns: The number of weathers.
     */
    func numberOfItems() -> Int {
        guard let sectionInfo = fetchedResultsController.sections?.first else {
            return 0
        }
        
        return sectionInfo.numberOfObjects
    }
}
