//
//  OnboardingItem.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 26/01/24.
//

import Foundation

struct OnboardingItem: Identifiable {
    let id: String
    let title: String?
    let description: String?
    let buttonTitle: String?
    let bgImage: String?
    
    init(
        id: String = UUID().uuidString,
        title: String?,
        description: String?,
        buttonTitle: String?,
        bgImage: String?
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.buttonTitle = buttonTitle
        self.bgImage = bgImage
    }
}

extension OnboardingItem {
    static let mocks: [OnboardingItem] = [
        .init(
            title: "Ready. Charge. Go",
            description: "Discover a large variety of the charge stations near you.",
            buttonTitle: "Next",
            bgImage: "Onboarding/1"
        ),
        .init(
            title: "Track Prices and Up-to-date stations",
            description: "Discover a large variety of the charge stations near you.",
            buttonTitle: "Start",
            bgImage: "Onboarding/2"
        ),
    ]
}


