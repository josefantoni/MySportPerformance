//
//  Double+Extension.swift
//  MySportPerformance
//
//  Created by Pepca on 22.06.2022.
//

import Foundation

extension Double {
    var formatDate: String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        return dateFormatter.string(from: date)
    }
}
