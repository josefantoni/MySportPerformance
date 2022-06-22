//
//  TimeTextFieldStyle.swift
//  MySportPerformance
//
//  Created by Pepca on 22.06.2022.
//

import SwiftUI

struct TimeTextFieldStyle: TextFieldStyle {
    var keyboardType: UIKeyboardType
    
    init(keyboardType: UIKeyboardType = .default) {
        self.keyboardType = keyboardType
    }

    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .overlay( RoundedRectangle(cornerRadius: 16).stroke(.purple, lineWidth: 2))
            .keyboardType(keyboardType)
    }
}
