import SwiftUI

@main
struct ExpenseroooApp: App {
    @StateObject private var dataController = DataController()

    var body: some Scene {
        WindowGroup {
          
                NavigationView {
                    BudgetListView()
                        .environment(\.managedObjectContext, dataController.container.viewContext)
                        .environmentObject(dataController) // Pass DataController as an environment object
                }
             
            
        }
    }
}

