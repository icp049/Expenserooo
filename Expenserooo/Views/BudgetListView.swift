import SwiftUI

struct BudgetListView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @EnvironmentObject var dataController: DataController // Access DataController as an environment object

    @FetchRequest(
        entity: Budget.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Budget.date, ascending: false)],
        animation: .default
    )
    
    
 

    var budgets: FetchedResults<Budget>
    
    @State private var showingAddView = false
    @State private var showingAddIncomeView = false
    @State private var showingIncomeView = false
    
    var body: some View {
        NavigationView {
            
          
            
            List {
                
                Section(header: Text("Total Overall Expense")) {
                        Text("\(formatAmount(calculateOverallTotalExpense()))")
                    }
              

                
                ForEach(budgets, id: \.id) { budget in
                    NavigationLink(destination: BudgetDetailView(budget: budget)) {
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
                                            Spacer()
                                            Text("\(expense.category ?? "")")
                                            
                                        }
                                    }
                                    
                                    // Display the total expense using the new function
                                    Text("Total Expense:")
                                    Text("\(formatAmount(calculateTotalExpense(expenses)))")
                                    
                                    
                                    
                                    Text("Extra Money:")
                                    Text("\(formatAmount(budget.income - calculateTotalExpense(expenses)))")
                                    
                                    
                                }
                            }
                        }
                    }
                }
                .onDelete(perform: deleteBudget)
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
            
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddIncomeView.toggle()
                    } label: {
                        Label("Add Account", systemImage: "plus")
                    }
                }
                
            }
            .sheet(isPresented: $showingAddIncomeView) {
                AddIncomeView()
            }
            
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingIncomeView.toggle()
                    } label: {
                        Label("Add Account", systemImage: "plus")
                    }
                }
                
            }
            .sheet(isPresented: $showingIncomeView) {
                IncomeView()
            }
            
            
            
            
        }
        .navigationViewStyle(.stack)
    }
    
    
    
    private func deleteBudget(offsets: IndexSet) {
            withAnimation {
                offsets.map { budgets[$0] }
                    .forEach(managedObjContext.delete)
                
                // Saves to our database
                DataController().save(context: managedObjContext)
            }
        }

    // Helper function to calculate total expense
    private func calculateTotalExpense(_ expenses: NSSet) -> Double {
        return expenses.allObjects.compactMap { ($0 as? Expense)?.amount }.reduce(0, +)
    }

    // Helper function to format amounts with two decimal places
    private func formatAmount(_ amount: Double) -> String {
        return String(format: "%.2f", amount)
    }
    
    
    // ...

    private func calculateOverallTotalExpense() -> Double {
        let overallTotalExpense = budgets.reduce(0) { (result, budget) in
            if let expenses = budget.expenses {
                return result + calculateTotalExpense(expenses)
            } else {
                return result
            }
        }
        return overallTotalExpense
    }

    // ...

}

struct BudgetListView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetListView()
    }
}

