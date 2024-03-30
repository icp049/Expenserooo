import SwiftUI

struct AddBudgetView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var sourceamount = ""
    @State private var expenseName = ""
    @State private var expenseCategory = "🏡 Rent/Mortgage"
    @State private var sourcecategory = "Chequing" //choice of saource budget defaults to chequing
    @State private var expenseAmount = ""
    @State private var totalexpense = ""
    @State private var extramoney = ""
    
    
    let categorySelection = ["🏡 Rent/Mortgage", "💸 Bills" ,"🏛 Loan", "🍽 Food", "✈️ Travel", "📱 Subscription", "😄 My Wants","👉 Essentials", "🚘 Transportation/Gas"]
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
                    .foregroundStyle(.secondary)
                    
                    
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
                        .foregroundStyle(.secondary)
                    
                    Picker("Expense Category", selection: $expenseCategory) {
                        ForEach(categorySelection, id: \.self) { category in
                            Text(category)
                            
                            
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .accentColor(.white)
                    
                    
                    Spacer()
                    
                }
                
                
                HStack{
                    
                    
                    Spacer()
                    
                    RUButton(title: "Add + " , background: .blue){
                        
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
                    
                    
                    
                }
                .padding(.top,15)
                
                
                VStack{
                    List{
                        ForEach(expenses, id: \.self) { expense in
                            HStack {
                                Spacer()
                                Text("\(expense.name ?? "")")
                                   // Adjust the width as needed
                                Spacer()
                                Text("\(expense.category ?? "")")
                                   // Adjust the width as needed
                                Spacer()
                                Text("\(expense.amount)")
                                  // Adjust the width as needed
                                Spacer()
                                Button(action: {
                                    if let index = expenses.firstIndex(of: expense) {
                                        expenses.remove(at: index)
                                    }
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                                Spacer()
                                
                            }
                            
                            
                        }
                    }
                    
                }
            
                .padding(.top, 20)

                
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

