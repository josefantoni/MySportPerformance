//
//  Helper.swift
//  MySportPerformance
//
//  Created by Pepca on 22.06.2022.
//

import Foundation

class Helper {
    /**
     *   PRIOR IMPL: I wanted to present number with floating point
     *   FUTURE TODO: if we want to present floating point, we cannot use Swifts's Double/Float. Go with NSDecimalNumber!
     */
    static func formatDuration(from seconds: Double) -> String {
        let (hr,  minf) = modf(seconds / 3600)
        let (min, secf) = modf(60 * minf)
        let sec = (60 * secf)
        var output: [String] = []
        if !hr.isZero { output.append("\(Int(hr))h") }
        if !min.isZero { output.append("\(Int(min))m") }
        if !sec.isZero { output.append("\(Int(sec))s") }
        return output.joined(separator: " ")
    }
    
    static func calcSecondsFromString(h: String,
                                      m :String,
                                      s: String) -> Double {
        var totalSeconds: Double = 0
        if let hours = Double(h) { totalSeconds = hours * 3600 }
        if let minues = Double(m) { totalSeconds += minues * 60 }
        if let seconds = Double(s) { totalSeconds += seconds }
        return totalSeconds
    }
}
