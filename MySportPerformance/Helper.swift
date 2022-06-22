//
//  Helper.swift
//  MySportPerformance
//
//  Created by Pepca on 22.06.2022.
//

import Foundation

class Helper {
    static func formatDuration(from seconds: Double) -> String {
        let (hr,  minf) = modf(seconds / 3600)
        let (min, secf) = modf(60 * minf)
        let sec = (60 * secf)
        var output = ""
        if !hr.isZero { output += "\(hr)h" }
        if !min.isZero { output += "\(min)m" }
        if !sec.isZero { output += "\(sec.clean)s" }
        return output
    }
    
    static func calcSecondsFromString(h: String,
                                      m :String,
                                      s: String) -> Double {
        var totalSeconds: Double = 0
        if let hours = Double(h) { totalSeconds = hours * 3600 }
        if let minues = Double(m) { totalSeconds = minues * 60 }
        if let seconds = Double(s) { totalSeconds += seconds }
        return totalSeconds
    }
}
