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
    
    
    let categorySelection = ["🏡 Crib", "💸 Bills" ,"🏛 Loan", "🍽 Eat Out", "✈️ Travel", "📱 Subscription", "😄 My Wants","👉 Essentials", "🚘 Gas", "🚌 Commute","🛒 Grocery","🤸‍♂️ Fitness" ]
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
                    
                    SmallAddButton(title: "Add + " , background: .blue){
                        
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
                
                
                VStack(){
                    List{
                        ForEach(expenses, id: \.self) { expense in
                            HStack {
                                
                                    Text("\(expense.name ?? "")")
                                        .frame(maxWidth: 160 ,alignment: .leading) // Adjust alignment as needed
                                    Spacer()
                               
                                    Text("\(expense.category ?? "")")
                                        .frame(maxWidth: 190 ,alignment: .leading)
                            
                                    Spacer()
                                    Text("\(formatAmount(expense.amount))")
                                        .frame(maxWidth: 50, alignment: .trailing) // Adjust alignment as needed
                                }
                            
                        }
                        .onDelete { indexSet in
                            expenses.remove(atOffsets: indexSet)
                            
                        }
                    }
                    
                }
                .frame(width: 450)
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





