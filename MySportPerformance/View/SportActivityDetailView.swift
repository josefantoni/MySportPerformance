//
//  SportActivityDetailView.swift
//  MySportPerformance
//
//  Created by Pepca on 22.06.2022.
//

import SwiftUI

struct SportActivityDetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var sportActivity: SportActivity
    
    var body: some View {
        tableView
        .navigationBarTitle(Text(sportActivity.name), displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }
    
    var tableView: some View {
        List {
            listRow(title: "Activity name:",
                    subtitle: sportActivity.name)
            listRow(title: "Place:",
                    subtitle: sportActivity.place)
            listRow(title: "Duration:",
                    subtitle: Helper.formatDuration(from: sportActivity.duration))
            listRow(title: "Created:",
                    subtitle: sportActivity.created.formatDate)
            listRow(title: "Stored:",
                    subtitle: sportActivity.isLocalObject ? "LOCAL" : "REMOTE")
        }
        .listStyle(InsetGroupedListStyle())
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
    
    @ViewBuilder
    func listRow(title: String, subtitle: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(subtitle)
                .multilineTextAlignment(.trailing)
        }
        .font(.subheadline)
        .listRowBackground(sportActivity.isLocalObject ? Color.blue : Color.green)
        .foregroundColor(.white)
    }
}
