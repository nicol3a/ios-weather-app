//
//  ForecastListViewModel.swift
//  Weather
//
//  Created by Nicolas Bichon on 05/08/16.
//  Copyright © 2016 Nicolas Bichon. All rights reserved.
//

import Foundation
import CoreData

protocol ForecastListViewModelDelegate: class {
    func forecastListViewModel(_ viewModel: ForecastListViewModel, didUpdateForecastListWithState state: State)
}

class ForecastListViewModel {
    var managedObjectContext: NSManagedObjectContext!
    var city: City!
    
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
    
    /// Loading all forecast weathers ordered by date.
    lazy var fetchedResultsController: NSFetchedResultsController<Weather> = {
        let fetchRequest = NSFetchRequest<Weather>(entityName: "Weather")
        fetchRequest.predicate = NSPredicate(format: "isForecast == 1 && city.cityID == %@", self.city.cityID!)
        let positionSort = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [positionSort]
        
        let fetchedResultsController = NSFetchedResultsController<Weather>(
            fetchRequest: fetchRequest,
            managedObjectContext: self.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        return fetchedResultsController
    }()
    
    weak var delegate: ForecastListViewModelDelegate?
    
    // MARK: - Accessors
    
    func title() -> String? {
        return city.name?.uppercased()
    }
    
    // MARK: - Downloading
    
    func downloadForecastList(_ completion: (() -> Void)? = nil) {
        state = .loading
        
        ForecastService(managedObjectContext: managedObjectContext).downloadForecastListBy(
            city,
            count: Constants.City.numberOfDays,
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
        delegate?.forecastListViewModel(self, didUpdateForecastListWithState: state)
    }

    fileprivate func failWithError(_ error: Error) {
        state = .failed(error)
        delegate?.forecastListViewModel(self, didUpdateForecastListWithState: state)
    }
    
    // MARK: - Fetching
    
    func fetchForecastList() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
        }
    }
    
    /**
     Returns the view model for the cell at an index.
     
     - returns: An `WeatherCellViewModel` object.
     */
    func itemAtIndex(_ index: Int) -> ForecastCellViewModel? {
        if numberOfItems() == 0 || index >= numberOfItems() {
            return nil
        }
        
        let weather = fetchedResultsController.object(at: IndexPath(row: index, section: 0))
        
        return ForecastCellViewModel(weather: weather, managedObjectContext: managedObjectContext)
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
