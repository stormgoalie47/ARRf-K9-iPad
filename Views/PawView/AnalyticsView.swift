//
//  AnalyticsView.swift
//  ARRf K9 iPad
//
//  Created by Addison Reed on 7/27/25.
//

import SwiftUI
import SwiftData

struct AnalyticsView: View {
    @Environment(\.modelContext) private var modelContext
        @Query private var parents: [Parent]
        @Query private var treats: [Treat]
    
    var body: some View {
        Text("Analytics View")
    }
}
