//
//  SportActivityDetailView.swift
//  MySportPerformance
//
//  Created by Pepca on 22.06.2022.
//

import SwiftUI

struct SportActivityDetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var sportActivity: SportActivityEntity

    var body: some View {
        NavigationView {
            VStack {
                
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }
    
    var backButton: some View {
        Button { presentationMode.wrappedValue.dismiss() } label: {
            Image(systemName: "arrow.left")
                .foregroundColor(.white)
                .frame(minWidth: 0, maxWidth: .infinity)
        }
        .background(.purple)
        .cornerRadius(20)
        .buttonStyle(.bordered)
    }
}
