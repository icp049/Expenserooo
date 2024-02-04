import SwiftUI
import CoreData
import LocalAuthentication

struct IncomeView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var income: FetchedResults<Income>
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Section(header: Text("Total Income: \(formatAmount(calculateOverallTotalIncome()))")) {
                    List {
                        ForEach(income) { income in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(income.name!)
                                    .bold()
                                Text("\(formatAmount(income.amount))")
                                    .bold()
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
        }
        .navigationViewStyle(.stack)
    }

    private func formatAmount(_ amount: Double) -> String {
        return String(format: "%.2f", amount)
    }

    private func calculateTotalIncome(_ amount: Double) -> Double {
        // Add any additional logic for calculating total income for a single entry
        return amount
    }

    
    private func calculateOverallTotalIncome() -> Double {
        let overallTotalIncome = income.reduce(0) { (result, income) in
            return result + calculateTotalIncome(income.amount)
        }
        return overallTotalIncome
    }

    
}

