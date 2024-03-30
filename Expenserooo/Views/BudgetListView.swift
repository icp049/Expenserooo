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
            VStack{
                HStack{
                    VStack(alignment: .leading){
                        Text("Total Income: \(formatAmount(totalIncome))")
                        Text("Total Savings: \(formatAmount(totalSavings))")
                        Text("Total Expenses: \(formatAmount(calculateTotalExpense()))")
                        Text("Total Extra: \(formatAmount(calculateExtraMoney()))")

                    }
                    
                    Spacer()
                }
                .padding(.top,10)
            
            ZStack{
                
                List {
                    
                    ForEach(budgets, id: \.id) { budget in
                       
                            ZStack(alignment:.leading){
                                NavigationLink(destination: BudgetDetailView(budget: budget, totalIncome: $totalIncome, totalSavings: $totalSavings)) {
                                    EmptyView()
                                }
                                .opacity(0)
                                VStack(alignment: .leading) {
                                    Text(budget.name ?? "")
                                        .font(.headline)
                                    
                                    Text("Sourced From: \(budget.sourcecategory ?? ""))")
                                        .foregroundColor(.secondary)
                                    
                                    Text("Budget: \(formatAmount(budget.sourceamount))")
                                        .foregroundColor(.secondary)
                                    
                                    // Display Expenses
                                    
                                }
                                .padding()
                                
                                
                            }
                        
                            .background(RoundedRectangle(cornerRadius: 12).fill(.gray))
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                        
                      
                    }
                    .onDelete(perform: deleteBudget)
                    
                }
                
                .listStyle(InsetListStyle())
                
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        
                        MainAddButton(title: "+", background: .blue){
                            showingAddView.toggle()
                        }
                        
                    }
                }
                .sheet(isPresented: $showingAddView) {
                    AddBudgetView(totalIncome: $totalIncome, totalSavings: $totalSavings)
                }
                
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

