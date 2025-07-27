//
//  ContentView.swift
//  ARRf K9 iPad
//
//  Created by Addison Reed on 7/26/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        MainTabView()
//        ParentsView()
//        PottyBreaksView()
    }

}

#Preview {
    ContentView()
        .modelContainer(for: Parent.self, inMemory: true)
}
