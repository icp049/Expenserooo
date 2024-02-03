//
//  ExpenseroooApp.swift
//  Expenserooo
//
//  Created by Ian Pedeglorio on 2024-02-02.
//

import SwiftUI

@main
struct ExpenseroooApp: App {
    
    
    @StateObject private var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
