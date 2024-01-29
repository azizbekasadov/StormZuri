//
//  OnboardingModels.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 26/01/24.
//

enum OnboardingModels {
    enum InitData {
        struct Request {}
        
        struct Response {
            let item: OnboardingItem
            let currentIndex: Int
            let numberOfPages: Int
        }
    }
    
    enum ErrorData {
        struct Request {}
        
        struct Response {
            let error: OnboardingProviderError
        }
    }
    
    enum ContinueButton {
        struct Request {}
        
        struct Response {
            let item: OnboardingItem?
            let currentIndex: Int
        }
    }
}
