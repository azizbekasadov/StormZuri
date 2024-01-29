//
//  MainButton.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 26/01/24.
//

import UIKit

final class MainButton: UIButton {
    enum Constants {
        enum Colors {
            static let backgroundColor: UIColor = .link
        }
        
        enum Fonts {
            static let titleFont: UIFont = .init(name: InterFontType.semibold.fontName, size: 16.0)!
        }
        
        enum Layers {
            static let cornerRadius: CGFloat = 12.0
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureViews()
    }
    
    init() {
        super.init(frame: .zero)
        
        configureViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureViews()
    }
    
    private func configureViews() {
        backgroundColor = Constants.Colors.backgroundColor
        titleLabel?.font = Constants.Fonts.titleFont
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = Constants.Layers.cornerRadius
    }
}
