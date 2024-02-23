import SwiftUI


struct BudgetDetailView: View {
    let budget: Budget
    
    @Binding var totalIncome: Double
    @Binding var totalSavings: Double

    
    @Environment(\.managedObjectContext) var managedObjContext
    @EnvironmentObject var dataController: DataController // Access DataController as an environment object
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(budget.name ?? "")
                .font(.headline)
            
            
            Text(budget.sourcecategory ?? "")
             
            
            Text("Amount Alloted: \(formatAmount(budget.sourceamount))")
                .foregroundColor(.secondary)

            if let expenses = budget.expenses {
                Section(header: Text("Expenses")) {
                    ForEach(expenses.allObjects as! [Expense], id: \.self) { expense in
                        HStack {
                            Text(expense.name ?? "")
                                .foregroundColor(.primary)
                            Spacer()
                            Text(expense.category ?? "")
                            Spacer()
                            Text("\(formatAmount(expense.amount))")
                        }
                    }

                    Text("Total Expense:")
                    Text("\(formatAmount(calculateTotalExpense(expenses)))")

                    Text("Extra Money:")
                    Text("\(formatAmount(budget.sourceamount - calculateTotalExpense(expenses)))")

                    // Integrate Pie Chart here
                    PieChartView(slices: prepareChartData(expenses: expenses))
                                           .frame(height: 200)
                                           .padding()                }
            }
            
            
            RUButton(title: "Forfeit", background: .red){
                forfeitBudget(budget: budget)
                
            }
            
            
            
        }
        .padding()
        .navigationTitle("Budget Details")
    }

    private func calculateTotalExpense(_ expenses: NSSet) -> Double {
        return expenses.allObjects.compactMap { ($0 as? Expense)?.amount }.reduce(0, +)
    }

    

    private func prepareChartData(expenses: NSSet) -> [(Double, Color)] {
        var categoryExpenses: [String: Double] = [:]

        // Calculate expenses for each category
        for expense in expenses.allObjects as! [Expense] {
            if let category = expense.category {
                categoryExpenses[category, default: 0] += expense.amount
            }
        }

        // Prepare data for PieChartView
        let chartData = categoryExpenses.map { (category, amount) in
            return (amount, getColorForCategory(category: category))
        }

        return chartData
    }

    private func getColorForCategory(category: String) -> Color {
        // You can customize this based on your desired color scheme
        switch category {
        case "Bills":
            return .red
        case "Leisure":
            return .blue
        case "Food":
            return .green
        default:
            return .gray
        }
    }
    
    
    private func forfeitBudget(budget: Budget) {
        if let sourceCategory = budget.sourcecategory {
            if sourceCategory == "Chequing" {
                totalIncome += budget.sourceamount
                UserDefaults.standard.set(totalIncome, forKey: "totalincome")
            } else if sourceCategory == "Savings" {
                totalSavings += budget.sourceamount
                UserDefaults.standard.set(totalSavings, forKey: "totalsavings")
            }

            budget.sourceamount = 0
            DataController().save(context: managedObjContext)
        }
    }

}

