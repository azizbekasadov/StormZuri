//
//  CoreCollectionViewCell.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 27/01/24.
//

import UIKit

class CoreCollectionViewCell: UICollectionViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
        setupLayout()
    }
}

extension CoreCollectionViewCell: UIConfigurable {
    func setupUI() { }
    
    func setupLayout() { }
}
