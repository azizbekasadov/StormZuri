//
//  UserLocationViewController.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 28/01/24.
//

import UIKit
import Stevia

protocol UserLocationDisplayLogic: AnyObject {
    func initViews(_ response: UserLocationModels.InitData.Response)
    func receivedError(_ response: UserLocationModels.ErrorData.Response)
    func receivedUserLocation(_ response: UserLocationModels.UserLocation.Response)
}

final class UserLocationViewController: CoreViewController {
    
    private let thumbImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.image = "UserLocation/thumb".image
        return img
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Ready to go? Almost!"
        label.font = InterFontType.semibold.fontType(size: 18)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    private let descLabel: UILabel = {
        let label = UILabel()
        label.text = "Allow us to track your current location in order to show your near by charging stations"
        label.font = InterFontType.regular.fontType(size: 14)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    private let pageControl: UIPageControl = {
        let pgc = UIPageControl()
        pgc.currentPageIndicatorTintColor = .link
        pgc.pageIndicatorTintColor = .white
        pgc.backgroundStyle = .prominent
        return pgc
    }()
    
    private lazy var textStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, descLabel])
        stack.spacing = 10
        stack.alignment = .fill
        stack.distribution = .fill
        stack.axis = .vertical
        return stack
    }()
    
    private let continueButton: MainButton = {
        let button = MainButton()
        button.setTitle("Continue", for: .normal)
        return button
    }()
    
    private var presenter: UserLocationPresentationLogic?
    
    init(presenter: UserLocationPresentationLogic?) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.initViews(.init())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        view.subviews(thumbImageView, textStackView, pageControl, continueButton)
        
        continueButton.addTapGesture { [weak self] in
            self?.continueButton.animateBounce()

            self?.presenter?.requestUserLocation(.init())
        }
    }
    
    override func setupLayout() {
        continueButton.Bottom == view.safeAreaLayoutGuide.Bottom - 30
        continueButton.width(240).height(50).centerHorizontally()
        
        pageControl.Bottom >= continueButton.Top - 30
        pageControl.centerHorizontally()
        
        textStackView.Bottom == pageControl.Top - 50
        textStackView.width(300).centerHorizontally()
        
        thumbImageView.Bottom == textStackView.Top - 50
        thumbImageView.centerHorizontally().centerVertically(offset: -30)
        thumbImageView.width(320)
        thumbImageView.heightEqualsWidth()
    }
}


extension UserLocationViewController: UserLocationDisplayLogic {
    func initViews(_ response: UserLocationModels.InitData.Response) {}
    
    func receivedError(_ response: UserLocationModels.ErrorData.Response) {
        showError(response.error.localizedDescription)
    }
    
    func receivedUserLocation(_ response: UserLocationModels.UserLocation.Response) {
        if response.isAllowedTracking {
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
            
            Navigation.makeMainAsRoot()
        } else {
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred(intensity: 3)
            
            showError("In order to use our app, we kindly ask you to provide your current location!") { _ in
                debugPrint("User Location failed")
                
                Navigation.makeMainAsRoot()
            }
        }
    }
}
