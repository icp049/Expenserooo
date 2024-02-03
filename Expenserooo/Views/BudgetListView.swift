import SwiftUI

struct BudgetListView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @EnvironmentObject var dataController: DataController // Access DataController as an environment object

    @FetchRequest(
        entity: Budget.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Budget.date, ascending: false)],
        animation: .default
    ) var budgets: FetchedResults<Budget>
    
    
    @State private var showingAddView = false
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(budgets, id: \.id) { budget in
                    VStack(alignment: .leading) {
                        Text(budget.name ?? "")
                            .font(.headline)
                        Text("Income: \(formatAmount(budget.income))")
                            .foregroundColor(.secondary)

                        // Display Expenses
                        if let expenses = budget.expenses {
                            Section(header: Text("Expenses")) {
                                ForEach(expenses.allObjects as! [Expense], id: \.self) { expense in
                                    HStack {
                                        Text("\(expense.name ?? "")")
                                        Spacer()
                                        Text("\(formatAmount(expense.amount))")
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddView.toggle()
                    } label: {
                        Label("Add Account", systemImage: "plus")
                    }
                }
                
            }
            .sheet(isPresented: $showingAddView) {
                AddBudgetView()
            }
        }
        .navigationViewStyle(.stack)
    }
}

// Helper function to format amounts with two decimal places
private func formatAmount(_ amount: Double) -> String {
    return String(format: "%.2f", amount)
}

