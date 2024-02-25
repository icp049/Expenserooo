import SwiftUI
import CoreData

struct AddIncomeView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataController: DataController // Access DataController as an environment object

    @FetchRequest(
        entity: Income.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Income.date, ascending: false)],
        animation: .default
    )
    var incomes: FetchedResults<Income>
    
    
    @FetchRequest(
        entity: Savings.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Savings.savingsdate, ascending: false)],
        animation: .default
    )
    var savings: FetchedResults<Savings>

    @State private var name = ""
    @State private var amount = ""
    @State private var savingsname = ""
    @State private var savingsamount = ""
    @Binding var totalIncome: Double
    @Binding var totalSavings: Double
    
    let defaults = UserDefaults.standard

    var body: some View {
        VStack {
            Text("Total Income: \(formatAmount(totalIncome))")

            VStack {
                TextField("Income Name", text: $name)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)

                TextField("Income Amount", text: $amount)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)

                Button("Add Income") {
                    let incomeAmount = Double(amount) ?? 0.0
                    dataController.addIncome(name: name, amount: incomeAmount, context: managedObjContext)
                    totalIncome += incomeAmount
                    name = ""
                    amount = ""
                    defaults.set(totalIncome, forKey: "totalincome") // Update totalIncome in UserDefaults
                }
                .padding()
                List {
                    ForEach(incomes, id: \.id) { income in
                        VStack(alignment: .leading) {
                            Text(income.name ?? "")
                                .font(.headline)
                            Text(formatAmount(income.amount))
                                .foregroundColor(.secondary)
                        }
                    }
                    
                }
            }
            
            
            VStack{
                TextField("Transfer Name", text: $savingsname)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                TextField("Transfer Amount", text: $savingsamount)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                Button("Transfer to Savings") {
                    transferToSavings()
                    let savingsAmount = Double(savingsamount) ?? 0.0
                    dataController.addSavings(savingsname: savingsname, savingsamount: savingsAmount, context: managedObjContext)
                    totalSavings += savingsAmount
                    savingsname = ""
                    savingsamount = ""
                    defaults.set(totalSavings, forKey: "totalsavings") // Update totalSavings in UserDefaults
                }


                Text("Total Savings: \(formatAmount(totalSavings))")
                    .foregroundColor(.green)
                
                List {
                    ForEach(savings, id: \.id) { saving in
                        VStack(alignment: .leading) {
                            Text(saving.savingsname ?? "")
                                .font(.headline)
                            Text("Income: \(formatAmount(saving.savingsamount))")
                                .foregroundColor(.secondary)
                        }
                    }
                  
                }
            }
        }
        .padding()
        .onAppear {
       
            if let savedTotalIncome = defaults.value(forKey: "totalincome") as? Double {
                    totalIncome = savedTotalIncome
                }

                // Load totalSavings from UserDefaults when the view appears
                if let savedTotalSavings = defaults.value(forKey: "totalsavings") as? Double {
                    totalSavings = savedTotalSavings
                }
            
            
        }
    }

    private func deleteIncome(offsets: IndexSet) {
        withAnimation {
            offsets.map { incomes[$0] }
                .forEach { income in
                    totalIncome -= income.amount
                    managedObjContext.delete(income)
                }

            dataController.save(context: managedObjContext)
            defaults.set(totalIncome, forKey: "totalincome") // Update totalIncome in UserDefaults after deletion
        }
    }


    private func deleteSavings(offsets: IndexSet) {
        withAnimation {
            offsets.map { savings[$0] }
                .forEach { saving in
                    totalSavings -= saving.savingsamount
                    managedObjContext.delete(saving)
                }

            dataController.save(context: managedObjContext)
            defaults.set(totalSavings, forKey: "totalsavings") // Update totalSavings in UserDefaults after deletion
        }
    }
    
   
    
    private func transferToSavings() {
        guard let savingsAmount = Double(savingsamount) else { return }
        guard var currentTotalIncome = defaults.value(forKey: "totalincome") as? Double else { return }

        // Deduct the transferred amount from totalIncome
        currentTotalIncome -= savingsAmount

        // Update totalIncome in UserDefaults
        defaults.set(currentTotalIncome, forKey: "totalincome")

        // Update totalIncome for the view
        totalIncome = currentTotalIncome
    }
}

