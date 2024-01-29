//
//  OnboardingViewController.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 26/01/24.
//

import UIKit
import Stevia

protocol OnboardingDisplayLogic: AnyObject {
    func initViews(_ response: OnboardingModels.InitData.Response)
    func receivedError(_ response: OnboardingModels.ErrorData.Response)
    func selectedItem(_ response: OnboardingModels.ContinueButton.Response)
}

final class OnboardingViewController: CoreViewController {
    
    private let thumbImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .redraw
        return img
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = InterFontType.semibold.fontType(size: 18)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    private let descLabel: UILabel = {
        let label = UILabel()
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
        return button
    }()
    
    private var presenter: OnboardingPresentationLogic?
    
    init(presenter: OnboardingPresentationLogic?) {
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
            self?.presenter?.selectedItem(.init())
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
        thumbImageView.Width == textStackView.Width
        thumbImageView.heightEqualsWidth()
    }
    
    private func configureViews(_ item: OnboardingItem, currentIndex: Int) {
        thumbImageView.image = item.bgImage?.image
        titleLabel.text = item.title
        descLabel.text = item.description
        continueButton.setTitle(item.buttonTitle, for: .normal)
        pageControl.currentPage = currentIndex
        
        view.layoutIfNeeded()
    }
}

extension OnboardingViewController: OnboardingDisplayLogic {
    func initViews(_ response: OnboardingModels.InitData.Response) {
        configureViews(response.item, currentIndex: response.currentIndex)
        pageControl.numberOfPages = response.numberOfPages
    }
    
    func receivedError(_ response: OnboardingModels.ErrorData.Response) {
        showError(response.error.localizedDescription)
    }
    
    func selectedItem(_ response: OnboardingModels.ContinueButton.Response) {
        if let item = response.item {
            configureViews(item, currentIndex: response.currentIndex)
        } else {
            Navigation.navigate(to: .userLocation, type: .present(config: .overFullScreen))
        }
    }
}
