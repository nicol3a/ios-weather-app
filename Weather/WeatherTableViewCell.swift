//
//  WeatherTableViewCell.swift
//  Weather
//
//  Created by Nicolas Bichon on 05/08/16.
//  Copyright © 2016 Nicolas Bichon. All rights reserved.
//

import UIKit
import AlamofireImage

class WeatherTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    var viewModel: WeatherCellViewModel? {
        didSet {
            setupCell()
        }
    }
    
    // MARK: - View Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()

        weatherImageView.af_cancelImageRequest()
        weatherImageView.layer.removeAllAnimations()
        weatherImageView.image = nil
    }
    
    // MARK: - Setup

    func setupCell() {
        cityNameLabel.text = viewModel?.cityName()
        temperatureLabel.text = viewModel?.temperature()
        
        // Download weather image icon
        let transition = UIImageView.ImageTransition.crossDissolve(Constants.Animation.interval)
        
        if let imageURL = viewModel?.imageURL() {
            weatherImageView.af_setImage(withURL: imageURL, imageTransition: transition)
        }
    }
}
