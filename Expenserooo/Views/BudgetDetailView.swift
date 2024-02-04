import SwiftUI

struct BudgetDetailView: View {
    let budget: Budget

    var body: some View {
        VStack(alignment: .leading) {
            Text(budget.name ?? "")
                .font(.headline)
            Text("Income: \(formatAmount(budget.income))")
                .foregroundColor(.secondary)

            if let expenses = budget.expenses {
                Section(header: Text("Expenses")) {
                    ForEach(expenses.allObjects as! [Expense], id: \.self) { expense in
                        HStack {
                       Spacer()
                            Text("\(formatAmount(expense.amount))")
                        }
                    }

                    Text("Total Expense:")
                    Text("\(formatAmount(calculateTotalExpense(expenses)))")

                    Text("Extra Money:")
                    Text("\(formatAmount(budget.income - calculateTotalExpense(expenses)))")
                }
            }
        }
        .padding()
        .navigationTitle("Budget Details")
    }

    private func calculateTotalExpense(_ expenses: NSSet) -> Double {
        return expenses.allObjects.compactMap { ($0 as? Expense)?.amount }.reduce(0, +)
    }

    private func formatAmount(_ amount: Double) -> String {
        return String(format: "%.2f", amount)
    }
}



