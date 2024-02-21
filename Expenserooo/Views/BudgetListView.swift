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
    @State private var showAddIncomeView = false
    
    @State private var totalIncome: Double = 0.0
    @State private var totalSavings: Double = 0.0
    
  
    
    var body: some View {
        NavigationView {
            
            List {
                
                VStack{
                    Text("Total Income: \(formatAmount(totalIncome))")
                    
                }
                
                ForEach(budgets, id: \.id) { budget in
                    NavigationLink(destination: BudgetDetailView(budget: budget)) {
                        VStack(alignment: .leading) {
                            Text(budget.name ?? "")
                                .font(.headline)
                            Text("Income: \(formatAmount(budget.sourceamount))")
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
                                    Text("\(formatAmount(budget.sourceamount - calculateTotalExpense(expenses)))")
                                    
                                    
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
                        Label("Add Budget", systemImage: "plus")
                    }
                }
                
            }
            .sheet(isPresented: $showingAddView) {
                AddBudgetView(totalIncome: $totalIncome)
            }
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showAddIncomeView.toggle()
                    } label: {
                        Label("Add Income", systemImage: "plus")
                    }
                }
                
            }
            .sheet(isPresented: $showAddIncomeView) {
                AddIncomeView(totalIncome: $totalIncome, totalSavings: $totalSavings)
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
    
    
}

struct BudgetListView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetListView()
    }
}

