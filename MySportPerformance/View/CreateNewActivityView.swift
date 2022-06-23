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
    @State var activityPlace: String = ""
    @State var activityHours: String = ""
    @State var activityMinutes: String = ""
    @State var activitySeconds: String = ""

    @State var errorTitle: [String] = []
    @State var isAlertShown: Bool = false
    @State var isPrefferedToBeLocallySaved: Bool = true
    
    init(viewModel: BoardViewModel) {
        self.boardViewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                TextField("Enter sport activity", text: $activityName)
                    .textFieldStyle(TimeTextFieldStyle())
                TextField("Enter place of occurence", text: $activityPlace)
                    .textFieldStyle(TimeTextFieldStyle())

                timeView
                remoteTypeView
                
                Spacer()
                proceedButton
            }
            .frame(minHeight: 0, maxHeight: .infinity)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("New sport activity")
            .padding([.vertical, .horizontal], 8)
            .toolbar {
                ToolbarItem {
                    dismissButton
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    var timeView: some View {
        HStack {
            TextField("Hours", text: $activityHours)
                .textFieldStyle(TimeTextFieldStyle(keyboardType: .decimalPad))
            TextField("Minutes", text: $activityMinutes)
                .textFieldStyle(TimeTextFieldStyle(keyboardType: .decimalPad))
            TextField("Seconds", text: $activitySeconds)
                .textFieldStyle(TimeTextFieldStyle(keyboardType: .decimalPad))
        }
    }
    
    var remoteTypeView: some View {
        HStack {
            Toggle("LOCAL", isOn: $isPrefferedToBeLocallySaved)
                .toggleStyle(CheckToggleStyle(color: .blue))
            let negate = Binding<Bool>(
                get: { !$isPrefferedToBeLocallySaved.wrappedValue },
                set: { $isPrefferedToBeLocallySaved.wrappedValue = !$0 }
            )

            Toggle("REMOTE", isOn: negate)
                .toggleStyle(CheckToggleStyle(color: .green))
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
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 40)
                .padding([.vertical, .horizontal], 8)
                .background(.purple)
                .foregroundColor(.white)
                .cornerRadius(20)
        })
        .alert(errorTitle.joined(separator: "\n"),
               isPresented: $isAlertShown) {
            Button("OK", role: .cancel) { }
        }
    }
    
    func proceedButtonAction() {
        let duration = Helper.calcSecondsFromString(h: activityHours,
                                                    m: activityMinutes,
                                                    s: activitySeconds)
        guard !self.activityName.isEmpty && !self.activityPlace.isEmpty && !duration.isZero else {
            errorTitle = []
            if activityName.isEmpty { errorTitle.append("Empty sport activity name") }
            if activityPlace.isEmpty { errorTitle.append("Empty place of occurence") }
            if duration.isZero { errorTitle.append("Empty duration") }
            isAlertShown.toggle()
            return
        }
        boardViewModel.addSportActivity(name: activityName,
                                        place: activityPlace,
                                        duration: duration,
                                        isLocalType: isPrefferedToBeLocallySaved)
        dismiss()
    }
}

struct CreateNewActivityView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewActivityView(viewModel: BoardViewModel())
    }
}
