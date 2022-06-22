//
//  CheckToggleStyle.swift
//  MySportPerformance
//
//  Created by Pepca on 21.06.2022.
//

import SwiftUI

struct CheckToggleStyle: ToggleStyle {
    var color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            VStack {
                Label {
                    configuration.label
                } icon: {}
                    .padding(.bottom, 2)
                Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(configuration.isOn ? color : .secondary)
                    .accessibility(label: Text(configuration.isOn ? "Checked" : "Unchecked"))
                    .imageScale(.large)
            }.padding(.vertical, 20)
        }
        .buttonStyle(PlainButtonStyle())
        .frame(minWidth: 0, maxWidth: .infinity)
        .overlay( RoundedRectangle(cornerRadius: 16).stroke(color, lineWidth: 2))
    }
}
