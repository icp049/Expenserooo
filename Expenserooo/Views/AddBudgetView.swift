import SwiftUI

struct AddBudgetView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var sourceamount = ""
    @State private var expenseName = ""
    @State private var expenseCategory = ""
    @State private var expenseAmount = ""
    
    let categorySelection = ["Bills","Leisure", "Food", "Travel"]
    
    
    @Binding var totalIncome: Double // Binding for total income
    
    @State private var expenses: [Expense] = []
    
    var body: some View {
        VStack {
            TextField("Budget Name", text: $name)
                .autocapitalization(.none)
                .autocorrectionDisabled()
            
            TextField("Budget Amount", text: $sourceamount)
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
                        
                        Button(action: {
                            if let index = expenses.firstIndex(of: expense) {
                                expenses.remove(at: index)
                            }
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                    
                }
            }
            
            Button("Add Budget") {
                guard let budgetAmount = Double(sourceamount) else { return }
                               totalIncome -= budgetAmount 
                DataController().addBudget(
                    name: name,
                    sourceamount: Double(sourceamount) ?? 0.0,
                    expenses: expenses,
                    context: managedObjContext)
                dismiss()
            }
            .padding()
        }
    }
}
