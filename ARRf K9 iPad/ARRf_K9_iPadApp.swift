//
//  ARRf_K9_iPadApp.swift
//  ARRf K9 iPad
//
//  Created by Addison Reed on 7/26/25.
//

import SwiftUI
import SwiftData

@main
struct ARRf_K9_iPadApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Parent.self,
            Treat.self,
            PottyBreak.self,
            Resource.self,
            Dog.self
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema, 
            isStoredInMemoryOnly: true
        )

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
