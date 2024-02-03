import SwiftUI

struct AddBudgetView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss

    @State private var name = ""
    @State private var amount = ""
    @State private var expenseName = ""
    @State private var expenseAmount = ""

    @State private var expenses: [Expense] = []

    var body: some View {
        Form {
            Section {
                TextField("Income Source", text: $name)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()

                TextField("Amount", text: $amount)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()

                HStack {
                    TextField("Expense Name", text: $expenseName)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()

                    TextField("Expense Amount", text: $expenseAmount)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()

                    Button("Add Expense") {
                        let newExpense = Expense(context: managedObjContext)
                        newExpense.name = expenseName
                        newExpense.amount = Double(expenseAmount) ?? 0.0

                        expenses.append(newExpense)
                        // Optionally clear the text fields after adding an expense
                        expenseName = ""
                        expenseAmount = ""
                    }
                }
            }

            Section(header: Text("Expenses")) {
                ForEach(expenses, id: \.self) { expense in
                    HStack {
                        Text("\(expense.name ?? "")")
                        Spacer()
                        Text("\(expense.amount)")
                    }
                }
            }

            Section {
                HStack {
                    Spacer()

                    Button("Add Income") {
                        DataController().addBudget(
                            name: name,
                            income: Double(amount) ?? 0.0,
                            expenses: expenses,
                            context: managedObjContext
                        )

                        // Optionally dismiss the view after adding the budget
                        dismiss()
                    }
                    .padding()

                    Spacer()
                }
            }
        }
    }
}

