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
    
    @State private var name = ""
    @State private var amount = ""
    @State private var totalIncome: Double = 0.0 // State variable to hold the total income
    
    var body: some View {
        
        
        
        VStack{
            
            TextField("Total Income", value: $totalIncome, formatter: NumberFormatter())
                .disabled(true)
                .padding()
            
        }
        .onAppear {
            totalIncome = calculateTotalIncome(incomes)
        }
        
        
        
        
        VStack {
            TextField("Income Name", text: $name)
                .autocapitalization(.none)
                .autocorrectionDisabled()
            
            TextField("Income Amount", text: $amount)
                .autocapitalization(.none)
                .autocorrectionDisabled()
            
            Button("Add Income") {
                let incomeAmount = Double(amount) ?? 0.0
                dataController.addIncome(name: name, amount: incomeAmount, context: managedObjContext)
                totalIncome += incomeAmount // Update total income
                name = ""
                amount = ""
            }
            .padding()
        }
        
        List {
            ForEach(incomes, id: \.id) { income in
                VStack(alignment: .leading) {
                    Text(income.name ?? "")
                        .font(.headline)
                    Text("Income: \(formatAmount(income.amount))")
                        .foregroundColor(.secondary)
                }
            }
            .onDelete(perform: deleteIncome)
        }
    }
    
    private func deleteIncome(offsets: IndexSet) {
        withAnimation {
            offsets.map { incomes[$0] }
                .forEach { income in
                    totalIncome -= income.amount // Deduct from total income
                    managedObjContext.delete(income)
                }
            
            dataController.save(context: managedObjContext)
        }
    }
    
    private func calculateTotalIncome(_ incomes: FetchedResults<Income>) -> Double {
        return incomes.reduce(0) { $0 + ($1.amount ?? 0) }
    }

}

