//
//  ListViewController.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 27/01/24.
//

import UIKit
import Stevia
import PerfectTools

protocol ListDisplayLogic: AnyObject {
    func initViews(_ response: ListModels.InitData.Response)
    func fetchData(_ response: ListModels.FetchData.Response)
    func receivedError(_ response: ListModels.ErrorData.Response)
    func fetchSortedData(_ response: ListModels.SortData.Response)
}

final class ListViewController: CoreViewController {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.contentInset = .init(top: 16, left: 12, bottom: 16, right: 12)
        cv.register(
            .init(
                nibName: ListCollectionViewCell.cellid,
                bundle: nil
            ), 
            forCellWithReuseIdentifier: ListCollectionViewCell.cellid
        )
        cv.delegate = self
        cv.dataSource = self
        cv.bounces = false
        cv.alwaysBounceVertical = false
        cv.alwaysBounceHorizontal = false
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    private let lastUpdateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.setContentHuggingPriority(.required, for: .vertical)
        label.font = InterFontType.medium.fontType(size: 14.0)
        label.textColor = UIColor(hex: 0x1C1D2E)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [lastUpdateLabel, collectionView])
        stack.spacing = 10
        stack.alignment = .fill
        stack.distribution = .fill
        stack.axis = .vertical
        return stack
    }()
    
    private let sortingButton: UIButton = {
        let button = UIButton()
        button.setImage("List/dsc".image, for: .normal)
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let aind = UIActivityIndicatorView(style: .medium)
        aind.tintColor = UIColor(hex: 0x1C1D2E)
        aind.hidesWhenStopped = true
        return aind
    }()
    
    var presenter: ListPresentationLogic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupLayout()
        
        sortingButton.addTapGesture {
            self.sortingButton.animateBounce()
            self.activityIndicator.startAnimating()
            self.presenter?.fetchSortedData(.init())
            
            self.sortingButton.setImage(
                self.presenter?.sortingType.image,
                for: .normal
            )
        }
        
        lastUpdateLabel.text = "Last update - \(AppStorage.lastUpdate.formatDateToString())"
        
        activityIndicator.startAnimating()
        presenter?.initViews(.init())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sortingButton.layer.cornerRadius = sortingButton.bounds.height * 0.5
    }
}

extension ListViewController {
    override func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        view.subviews(activityIndicator, stackView)
        
        let leftTitleLabel = UILabel()
        leftTitleLabel.font = InterFontType.semibold.fontType(size: 22)
        leftTitleLabel.textColor = UIColor(hex: 0x1C1D2E)
        leftTitleLabel.text = "Charging Stations"
        leftTitleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        leftTitleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        navigationItem.leftBarButtonItem = .init(customView: leftTitleLabel)
        
        navigationItem.rightBarButtonItem = .init(customView: sortingButton)
    }
    
    override func setupLayout() {
        stackView
            .fillHorizontally()
            .bottom(16.0)
            .centerHorizontally()
            .Top == view.safeAreaLayoutGuide.Top + 10
        
        activityIndicator.centerInContainer()
    }
}

extension ListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard 
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.cellid, for: indexPath) as? ListCollectionViewCell,
            let item = presenter?.listItems[safe: indexPath.item]
        else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let leftOffset = collectionView.contentInset.left
        let rightOffset = collectionView.contentInset.right
        let width = collectionView.bounds.width - (leftOffset + rightOffset)
        return .init(width: width, height: 80.0)
    }
}

extension ListViewController: ListDisplayLogic {
    func initViews(_ response: ListModels.InitData.Response) {
        presenter?.fetchData(.init())
    }
    
    func fetchData(_ response: ListModels.FetchData.Response) {
        activityIndicator.stopAnimating()
        collectionView.reloadData()
        
        lastUpdateLabel.text = "Last update - \(AppStorage.lastUpdate.formatDateToString())"
    }
    
    func receivedError(_ response: ListModels.ErrorData.Response) {
        if activityIndicator.isAnimating {
            activityIndicator.stopAnimating()
        }
        showError(response.error.localizedDescription)
    }
    
    func fetchSortedData(_ response: ListModels.SortData.Response) {
        activityIndicator.stopAnimating()
        collectionView.reloadData()
        
        lastUpdateLabel.text = "Last update - \(AppStorage.lastUpdate.formatDateToString())"
    }
}
