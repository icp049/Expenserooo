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
    @Binding var totalIncome: Double // Binding for total income

    // Option 1: Declare totalSavings as a binding
    @Binding var totalSavings: Double

    // Option 2: Use a computed property for totalSavings
//    private var totalSavings: Double {
//        totalIncome - (Double(savingsAmount) ?? 0.0)
//    }

    var body: some View {
        VStack {
            Text("Total Income: \(formatAmount(totalIncome))")

            VStack {
                TextField("Transfer Amount", text: $savingsAmount)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()

                Button("Transfer to Savings") {
                    transferToSavings()
                }
                
                // Option 1: Display totalSavings using binding
                Text("Total Savings: \(formatAmount(totalSavings))")
                    .foregroundColor(.green)

                // Option 2: Display totalSavings using computed property
//                Text("Total Savings: \(formatAmount(totalSavings))")
//                    .foregroundColor(.green)
            }

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
        .padding()
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

    private func transferToSavings() {
        // Option 1: Access totalSavings as a binding
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
