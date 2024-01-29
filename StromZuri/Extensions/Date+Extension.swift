//
//  Date+Extension.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 29/01/24.
//

import Foundation

extension Date {
    func formatDateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy hh:mm a"
        
        let dateString = dateFormatter.string(from: self)
        
        return dateString
    }
}
