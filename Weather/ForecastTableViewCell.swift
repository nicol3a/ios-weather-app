//
//  ForecastTableViewCell.swift
//  Weather
//
//  Created by Nicolas Bichon on 05/08/16.
//  Copyright © 2016 Nicolas Bichon. All rights reserved.
//

import UIKit
import AlamofireImage

class ForecastTableViewCell: WeatherTableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var weatherTitle: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    
    // MARK: - Setup
    
    override func setupCell() {
        super.setupCell()
        
        guard let viewModel = viewModel as? ForecastCellViewModel else {
            return
        }
        
        cityNameLabel.text = viewModel.day()
        weatherTitle.text = viewModel.title()
        weatherDescription.text = viewModel.description()
    }
}
