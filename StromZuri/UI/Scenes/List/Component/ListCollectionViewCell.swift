//
//  ListCollectionViewCell.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 27/01/24.
//

import UIKit

final class ListCollectionViewCell: CoreCollectionViewCell {

    static let cellid: String = "\(ListCollectionViewCell.self)"
    
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var chargingPowerLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
    @IBOutlet private weak var availabilityLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    
    @discardableResult
    func configure(with item: ListItem) -> Self {
        titleLabel.text = item.stationName
        distanceLabel.text = item.distance
        availabilityLabel.text = item.available
//        iconImageView.image = item.icon.image
        chargingPowerLabel.text = item.chargingPower
        
        return self
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cleanUpUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconImageView.layer.cornerRadius = 10.0
        mainView.layer.cornerRadius = 16.0
    }
    
    private func cleanUpUI() {
        titleLabel.text = nil
        distanceLabel.text = nil
        availabilityLabel.text = nil
//        iconImageView.image = nil // for temp
        chargingPowerLabel.text = nil
    }
}
