import SwiftUI

@main
struct ExpenseroooApp: App {
    @StateObject private var dataController = DataController()

    var body: some Scene {
        WindowGroup {
            TabView {
                // BudgetListView inside the first tab
                BudgetListView()
                    .environment(\.managedObjectContext, dataController.container.viewContext)
                    .environmentObject(dataController) // Pass DataController as an environment object
                    .tabItem {
                        Image(systemName: "list.dash")
                        Text("Budget")
                    }
                
                // HomeView inside the second tab
                HomeView()
                    .environment(\.managedObjectContext, dataController.container.viewContext)
                    .environmentObject(dataController) // Pass DataController as an environment object
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
            }
        }
    }
}

