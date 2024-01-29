//
//  GlobalConstants.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 25/01/24.
//

import UIKit

public enum GlobalConstants {
    
    // MARK: - Public
    
    public static let orientation: UIDeviceOrientation = .portrait
    
    public enum URLs {
        case terms
        case privacy
        
        private static let termsLink: String = "~custom link here~"
        private static let privacyLink: String = "~custom link here~"
        
        public var url: URL {
            var link: String = ""
            switch self {
            case .privacy:
                link = URLs.termsLink
            case .terms:
                link = URLs.privacyLink
            }
            
            return URL(string: link)!
        }
    }
    
    // MARK: - Internal
    
    static let bundleID: String = Bundle.main.bundleIdentifier ?? "azizbekasadov.StromZuri"
    
    static let dbName: String = "DB"
}
