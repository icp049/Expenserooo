import SwiftUI

@main
struct ExpenseroooApp: App {
    @StateObject private var dataController = DataController()

    var body: some Scene {
        WindowGroup {
            TabView {
         
                
                NavigationView {
                    HomeView()
                }
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                
                
                
                NavigationView {
                    BudgetListView()
                        .environment(\.managedObjectContext, dataController.container.viewContext)
                        .environmentObject(dataController) // Pass DataController as an environment object
                }
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Budget List")
                }
            }
        }
    }
}

