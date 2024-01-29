//
//  OnboardingPresenter.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 26/01/24.
//


protocol OnboardingPresentationLogic: AnyObject {
    func initViews(_ request: OnboardingModels.InitData.Request)
    func selectedItem(_ request: OnboardingModels.ContinueButton.Request)
}

final class OnboardingPresenter: OnboardingPresentationLogic {
    private let dataProvider: OnboardingDataProvider
    
    private var items: [OnboardingItem] = []
    private var currentIndex: Int = 0
    
    weak var view: OnboardingDisplayLogic?
    
    init(dataProvider: OnboardingDataProvider) {
        self.dataProvider = dataProvider
    }
    
    func initViews(_ request: OnboardingModels.InitData.Request) {
        dataProvider.fetchData { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let success):
                guard let item = success[safe: 0] else { return }
                
                let response = OnboardingModels.InitData.Response(
                    item: item,
                    currentIndex: self.currentIndex,
                    numberOfPages: self.items.count
                )
                self.items = success
                self.view?.initViews(response)
            case .failure(let failure):
                let response = OnboardingModels.ErrorData.Response(error: failure)
                self.view?.receivedError(response)
            }
        }
    }
    
    func selectedItem(_ request: OnboardingModels.ContinueButton.Request) {
        let response: OnboardingModels.ContinueButton.Response
        
        if currentIndex == self.items.count - 1 {
            AppStorage.didFinishOnboarding = true
            response = .init(item: nil, currentIndex: currentIndex)
        } else {
            currentIndex += 1
            response = .init(item: items[currentIndex], currentIndex: currentIndex)
        }
        
        view?.selectedItem(response)
    }
}
