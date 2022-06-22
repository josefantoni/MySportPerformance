//
//  ActivityTableCell.swift
//  MySportPerformance
//
//  Created by Pepca on 22.06.2022.
//

import SwiftUI

struct ActivityTableCell: View {
    var localActivity: SportActivityEntity?
    
    var body: some View {
        if let localActivity = localActivity,
           let name = localActivity.name {
            HStack {
                Text(name)
                    .font(.subheadline)
                Text(Helper.formatDuration(from: localActivity.duration))
                    .font(.subheadline)
            }
            .padding(.horizontal, 8)
            .frame(minHeight: 50, maxHeight: .infinity)
        }
    }
}
