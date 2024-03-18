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
    
    @State private var totalIncome: Double = UserDefaults.standard.double(forKey: "totalincome")
    @State private var totalSavings: Double = UserDefaults.standard.double(forKey: "totalsavings")
   
   
    
    var body: some View {
        NavigationView {
            

            List {
                
                VStack{
                    Text("Total Income: \(formatAmount(totalIncome))")
                    Text("Total Savings: \(formatAmount(totalSavings))")
                    Text("Total Expenses: \(formatAmount(calculateTotalExpense()))")
                    Text("Total Extra: \(formatAmount(calculateExtraMoney()))")
                    
                    
                }
                
             
                
                
                ForEach(budgets, id: \.id) { budget in
                    NavigationLink(destination: BudgetDetailView(budget: budget, totalIncome: $totalIncome, totalSavings: $totalSavings)) {
                        VStack(alignment: .leading) {
                            Text(budget.name ?? "")
                                .font(.headline)
                            
                            Text("Sourced From: \(budget.sourcecategory ?? ""))")
                                .foregroundColor(.secondary)
                            
                            Text("Budget: \(formatAmount(budget.sourceamount))")
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
                                    Text("\(formatAmount(budget.totalexpense))")
                                    
                                    
                                    
                                    Text("Extra Money:")
                                    Text("\(formatAmount(budget.extramoney))")
                                    
                                    
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
                AddBudgetView(totalIncome: $totalIncome, totalSavings: $totalSavings)
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
    
    
    private func calculateTotalExpense() -> Double {
          return budgets.map { $0.totalexpense }.reduce(0, +)
      }
      
      private func calculateExtraMoney() -> Double {
          return budgets.map { $0.extramoney }.reduce(0, +)
      }
    
  
    
   
    
}

struct BudgetListView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetListView()
    }
}

