import SwiftUI

struct AddBudgetView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var sourceamount = ""
    @State private var expenseName = ""
    @State private var expenseCategory = "Bills"
    @State private var sourcecategory = "Chequing" //choice of saource budget defaults to chequing
    @State private var expenseAmount = ""
    @State private var totalexpense = ""
    @State private var extramoney = ""
    
    
    let categorySelection = ["Rent/Mortgage","Loan", "Food", "Travel", "Subscription", "My Wants","Essentials", "Transportation/Gas"]
    let sourceSelection = ["Chequing", "Savings"]
    
    
    
    @Binding var totalIncome: Double
    @Binding var totalSavings: Double // Binding for total income// Binding for total income
    
    @State private var expenses: [Expense] = []
    
    var body: some View {
        
        
        
        
        Text("B U D G E T I N G")
            .font(.system(size:25))
            .padding(.top,20)
        
        
        VStack {
            
            
            VStack{
                HStack{
                    
                    Text("Get it from")
                    
                    
                    Picker("Source", selection: $sourcecategory) {
                        ForEach(sourceSelection, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
            }
            
            TextField("Budget Name", text: $name)
                .autocapitalization(.none)
                .autocorrectionDisabled()
            
            
            
            
            
            TextField("Budget Amount", text: $sourceamount)
                .autocapitalization(.none)
                .autocorrectionDisabled()
            
            
            
            
            
            VStack{
                
                Text("M Y  E X P E N S E S")
                  
                
                
                TextField("Expense Name", text: $expenseName)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                
                
                
                TextField("Expense Amount", text: $expenseAmount)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                
                
                HStack {
                    
                    Text("Category")
                    
                    Picker("Expense Category", selection: $expenseCategory) {
                        ForEach(categorySelection, id: \.self) { category in
                            Text(category)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    Spacer()
                    
                }
                
                
                
                
                RUButton(title: "Add Expense" , background: .red){
                    
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
                
                
                
                Section{
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
                .padding(.top,30)
                
            }
            .padding(.top,50)
            
            
            
            
            
            
        }
        .padding(.top,30)
        .padding(.horizontal,20)
        
        Spacer()
        
        
        RUButton(title: "Add Budget", background:.green){
            
            
            let totalExpense = calculateTotalExpense(expenses)
            let sourceAmountDouble = Double(sourceamount) ?? 0.0
            let extraMoney = sourceAmountDouble - totalExpense
            
            
            
            
            if sourcecategory == "Chequing" {
                guard let budgetAmount = Double(sourceamount) else { return }
                totalIncome -= budgetAmount
                UserDefaults.standard.set(totalIncome, forKey: "totalincome")
            } else if sourcecategory == "Savings" {
                guard let budgetAmount = Double(sourceamount) else { return }
                totalSavings -= budgetAmount
                UserDefaults.standard.set(totalSavings, forKey: "totalsavings")
            }
            
            
            
            
            
            DataController().addBudget(
                name: name,
                sourcecategory: sourcecategory,
                sourceamount: Double(sourceamount) ?? 0.0,
                expenses: expenses,
                totalexpense: totalExpense,
                extramoney: extraMoney,
                context: managedObjContext)
            dismiss()
            
        }
        
    }
}




private func calculateTotalExpense(_ expenses: [Expense]) -> Double {
    return expenses.map { $0.amount }.reduce(0, +)
}

