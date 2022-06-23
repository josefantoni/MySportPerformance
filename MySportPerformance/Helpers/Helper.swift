//
//  Helper.swift
//  MySportPerformance
//
//  Created by Pepca on 22.06.2022.
//

import Foundation

class Helper {
    /**
     *     This horrible monster is the only way i found out how to format my seconds like 
     */
    static func formatDuration(from seconds: Double) -> String {
        let (hr,  minf) = modf(seconds / 3600)
        let (min, secf) = modf(60 * minf)
        let sec = (60 * secf)
        var output: [String] = []
        if !hr.isZero { output.append("\(Int(hr))h") }
        if !min.isZero { output.append("\(Int(min))m") }
        if !sec.isZero {
            let stringFromNumber = String(sec)
            if let dotIndex = stringFromNumber.range(of: ".")?.upperBound {
                let charactersCount = stringFromNumber.count
                let distancToDot = stringFromNumber.distance(from: stringFromNumber.startIndex, to: dotIndex)

                if charactersCount > (distancToDot + 1){
                    let endIndex = stringFromNumber.index(dotIndex, offsetBy:2)
                    output.append("\(stringFromNumber[..<endIndex])s")
                } else if charactersCount > distancToDot {
                    let endIndex = stringFromNumber.index(dotIndex, offsetBy:1)
                    let endChar = stringFromNumber[..<endIndex]
                    if let last = endChar.last, last.description == "0" {
                        output.append("\(Int(sec))s")
                    } else {
                        output.append("\(stringFromNumber[..<endIndex])s")
                    }
                }
            } else {
                output.append("\(Int(sec))s")
            }
        }
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
