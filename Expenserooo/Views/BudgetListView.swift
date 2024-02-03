import SwiftUI

struct BudgetListView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @EnvironmentObject var dataController: DataController // Access DataController as an environment object

    @FetchRequest(
        entity: Budget.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Budget.date, ascending: false)],
        animation: .default
    ) var budgets: FetchedResults<Budget>

    var body: some View {
        NavigationView {
            List {
                ForEach(budgets, id: \.id) { budget in
                    VStack(alignment: .leading) {
                        Text(budget.name ?? "")
                            .font(.headline)
                        Text("Income: \(budget.income)")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationBarTitle("Budgets")
        }
    }
}

