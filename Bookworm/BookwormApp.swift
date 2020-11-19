//
//  BookwormApp.swift
//  Bookworm
//
//  Created by Eman Elrefai on 11/12/20.
//

import SwiftUI

@main
struct BookwormApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
