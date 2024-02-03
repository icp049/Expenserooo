import SwiftUI

struct AddIncomeView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss

    @State private var name = ""
    @State private var amount = ""

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
                    Spacer()

                    RUButton(title: "Add Income", background: .black) {
                        DataController().addIncome(
                            name: name,
                            amount: Double(amount) ?? 0.0,
                            context: managedObjContext
                        )
                    }
                    .padding()

                    Spacer()
                }
            }
        }
    }
}

struct AddIncomeView_Previews: PreviewProvider {
    static var previews: some View {
        AddIncomeView()
    }
}

