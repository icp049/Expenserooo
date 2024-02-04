import SwiftUI

struct AddBudgetView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss

    @State private var name = ""
    @State private var amount = ""
    @State private var expenseName = ""
    @State private var expenseCategory = ""
    @State private var expenseAmount = ""
    
    let categorySelection = ["Bills","Leisure", "Food", "Travel"]
    
    @State private var expenses: [Expense] = []

    var body: some View {
        VStack {
            TextField("Income Source", text: $name)
                .autocapitalization(.none)
                .autocorrectionDisabled()

            TextField("Amount", text: $amount)
                .autocapitalization(.none)
                .autocorrectionDisabled()

            TextField("Expense Name", text: $expenseName)
                .autocapitalization(.none)
                .autocorrectionDisabled()

            Picker("Expense Category", selection: $expenseCategory) {
                ForEach(categorySelection, id: \.self) { category in
                    Text(category)
                }
            }
            .pickerStyle(MenuPickerStyle())

            TextField("Expense Amount", text: $expenseAmount)
                .autocapitalization(.none)
                .autocorrectionDisabled()

            Button("Add Expense") {
                let newExpense = Expense(context: managedObjContext)
                newExpense.name = expenseName
                newExpense.category = expenseCategory
                newExpense.amount = Double(expenseAmount) ?? 0.0

                expenses.append(newExpense)
                // Optionally clear the text fields after adding an expense
                expenseName = ""
                expenseCategory = ""
                expenseAmount = ""
            }

            Section(header: Text("Expenses")) {
                ForEach(expenses, id: \.self) { expense in
                    HStack {
                        Text("\(expense.name ?? "")")
                        Spacer()
                        Text("\(expense.category ?? "")")
                        Spacer()
                        Text("\(expense.amount)")
                        Spacer()
                    }
                }
            }

            Button("Add Income") {
                DataController().addBudget(
                    name: name,
                    income: Double(amount) ?? 0.0,
                    expenses: expenses,
                    context: managedObjContext)
                dismiss()
            }
            .padding()
        }
    }
}

