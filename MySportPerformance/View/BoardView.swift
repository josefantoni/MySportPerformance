//
//  BoardsView.swift
//
//  Created by Pepca on 21.06.2022.
//

import SwiftUI
import CoreData

struct BoardsView: View {
    @StateObject var boardViewModel: BoardViewModel = BoardViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(boardViewModel.storedSportActivities) { item in
                    NavigationLink {
                        Text("Item at \(item.name ?? "?")")
                    } label: {
                        Text(item.name ?? "")
                    }
                }
                .onDelete(perform: boardViewModel.removeSportActivity)
                Button(action: {
                    boardViewModel.addSportActivity(name: "123")
                }, label: {
                    Text("123")
                })
            }
        }
    }
}
