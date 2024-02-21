import SwiftUI

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
    @State private var savingsAmount = ""
    @Binding var totalIncome: Double
    @Binding var totalSavings: Double

    var body: some View {
        VStack {
            Text("Total Income: \(formatAmount(totalIncome))")

            VStack {
                TextField("Transfer Amount", text: $savingsAmount)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)

                Button("Transfer to Savings") {
                    transferToSavings()
                }

                Text("Total Savings: \(formatAmount(totalSavings))")
                    .foregroundColor(.green)
            }

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
            }
            .padding()

            VStack {
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
        }
        .padding()
    }

    private func deleteIncome(offsets: IndexSet) {
        withAnimation {
            offsets.map { incomes[$0] }
                .forEach { income in
                    totalIncome -= income.amount
                    managedObjContext.delete(income)
                }

            dataController.save(context: managedObjContext)
        }
    }

    private func transferToSavings() {
        guard let amount = Double(savingsAmount) else {
            return
        }

        guard amount >= 0 else {
            return
        }

        guard totalIncome >= amount else {
            return
        }

        totalIncome -= amount
        totalSavings += amount

        savingsAmount = ""
    }
    
   
}

