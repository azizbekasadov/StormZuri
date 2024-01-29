//
//  OnboardingDataProvider.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 26/01/24.
//

enum OnboardingProviderError: Error {
    case noItemsFound
    case unspecified
}

protocol OnboardingDataProvider {
    func fetchData(completion: @escaping(Result<[OnboardingItem], OnboardingProviderError>)->Void)
}

final class OnboardingDataProviderImp: OnboardingDataProvider {
    func fetchData(completion: @escaping (Result<[OnboardingItem], OnboardingProviderError>) -> Void) {
        let queue = DispatchQueue(label: GlobalConstants.bundleID + "fetch.onboarding", qos: .utility)
        queue.async {
            let mocks = OnboardingItem.mocks
            
            DispatchQueue.main.async {
                if mocks.isEmpty {
                    completion(.failure(.noItemsFound))
                } else {
                    completion(.success(mocks))
                }
            }
        }
    }
}

