//
//  BoardsView.swift
//
//  Created by Pepca on 21.06.2022.
//

import SwiftUI
import CoreData

enum eSportActivityType: Hashable {
    case all
    case local
    case remote
}

struct BoardsView: View {
    @StateObject private var boardViewModel: BoardViewModel = BoardViewModel()
    @State private var isSheetPresented = false
    
    var body: some View {
        NavigationView {
            VStack {
                segmentView
                tableView
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("My sport performance")
            .toolbar {
                ToolbarItem() {
                    addButton
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    var segmentView: some View {
        Picker("", selection: $boardViewModel.sportActivityType) {
            Text("All").tag(eSportActivityType.all)
            Text("Local").tag(eSportActivityType.local)
            Text("Remote").tag(eSportActivityType.remote)
        }
        .pickerStyle(.segmented)
    }
    
    var tableView: some View {
        List {
            ForEach(boardViewModel.filteredSportActivities, id: \.id) { sportActivity in
                NavigationLink {
                    SportActivityDetailView(sportActivity: sportActivity)
                } label: {
                    listRow(title: sportActivity.name,
                            subtitle: Helper.formatDuration(from: sportActivity.duration))
                }
                .listRowBackground(sportActivity.isLocalObject ? Color.blue : Color.green)
                .foregroundColor(.white)
            }
            .onDelete(perform: boardViewModel.removeSportActivity)
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    var addButton: some View {
        Button(action: {
            isSheetPresented.toggle()
        }, label: {
            Image(systemName: "plus")
                .foregroundColor(.white)
                .frame(minWidth: 0,
                       maxWidth: .infinity)
        })
        .background(Color.purple)
        .cornerRadius(20)
        .buttonStyle(.bordered)
        .sheet(isPresented: $isSheetPresented) { CreateNewActivityView(viewModel: boardViewModel) }
    }
        
    @ViewBuilder
    func listRow(title: String, subtitle: String) -> some View {
        HStack {
            Text("\(title): \(subtitle)")
                .font(.subheadline)
        }
        .padding(.horizontal, 8)
        .frame(minHeight: 50, maxHeight: .infinity)
    }
}

struct BoardsView_Previews: PreviewProvider {
    static var previews: some View {
        BoardsView()
    }
}
