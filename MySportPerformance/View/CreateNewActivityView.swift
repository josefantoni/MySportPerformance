//
//  CreateNewActivityView.swift
//  MySportPerformance
//
//  Created by Pepca on 21.06.2022.
//

import Foundation
import SwiftUI

struct CreateNewActivityView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var boardViewModel: BoardViewModel
    
    @State var activityName: String = ""
    @State var isAlertShown: Bool = false
    @State var isPrefferedToBeLocallySaved: Bool = true
    
    init(viewModel: BoardViewModel) {
        self.boardViewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
                content
                proceedButton
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("New sport activity")
            .padding(.horizontal, 8)
            .toolbar {
                ToolbarItem {
                    dismissButton
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    var content: some View {
        VStack {
            TextField("Enter sport activity", text: $activityName)
                .padding()
                .overlay( RoundedRectangle(cornerRadius: 16).stroke(.purple, lineWidth: 2))
            
            HStack {
                Toggle("LOCAL", isOn: $isPrefferedToBeLocallySaved)
                    .toggleStyle(CheckToggleStyle())
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .overlay( RoundedRectangle(cornerRadius: 16).stroke(.purple, lineWidth: 2))
                let negate = Binding<Bool>(
                    get: { !$isPrefferedToBeLocallySaved.wrappedValue },
                    set: { $isPrefferedToBeLocallySaved.wrappedValue = !$0 }
                )

                Toggle("REMOTE", isOn: negate)
                    .toggleStyle(CheckToggleStyle())
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .overlay( RoundedRectangle(cornerRadius: 16).stroke(.purple, lineWidth: 2))
            }
        }
    }
    
    var dismissButton: some View {
        Button { dismiss() } label: {
            Image(systemName: "xmark")
                .foregroundColor(.white)
                .frame(minWidth: 0, maxWidth: .infinity)
        }
        .background(.purple)
        .cornerRadius(20)
        .buttonStyle(.bordered)
    }
    
    var proceedButton: some View {
        Button(action: proceedButtonAction, label: {
            Text("Save")
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .background(.purple)
                .foregroundColor(.white)
                .cornerRadius(20)
        })
        .alert("Empty sport activity cannot be saved!",
               isPresented: $isAlertShown) {
            Button("OK", role: .cancel) { }
        }
    }
    
    func proceedButtonAction() {
        guard !self.activityName.isEmpty else {
            isAlertShown.toggle()
            return
        }
        if isPrefferedToBeLocallySaved {
            boardViewModel.addSportActivity(name: activityName)
        } else {
            fatalError("Yet to be implented!")
        }
        dismiss()
    }
}

struct CreateNewActivityView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewActivityView(viewModel: BoardViewModel())
    }
}
