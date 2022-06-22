//
//  BoardsView.swift
//
//  Created by Pepca on 21.06.2022.
//

import SwiftUI
import CoreData

struct BoardsView: View {
    @StateObject private var boardViewModel: BoardViewModel = BoardViewModel()
    @State private var isSheetPresented = false
    
    var body: some View {
        NavigationView {
            VStack {
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
    
    var tableView: some View {
        List {
            ForEach(boardViewModel.storedSportActivities) { item in
                NavigationLink {
                    Text("Item at \(item.name ?? "?")")
                } label: {
                    ActivityTableCell(localActivity: item)
                }
                .listRowBackground(Color.blue)
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
    
    var preferencesButton: some View {
        Button(action: {
            
        }, label: {
            Image(systemName: "slider.horizontal.3")
                .foregroundColor(.white)
                .frame(minWidth: 0,
                       maxWidth: .infinity)
        }).background(Color.purple)
            .cornerRadius(20)
            .buttonStyle(.bordered)
    }
}

struct BoardsView_Previews: PreviewProvider {
    static var previews: some View {
        BoardsView()
    }
}
