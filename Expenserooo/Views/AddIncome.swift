import SwiftUI

struct AddIncomeView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var amount = ""
   
    

    
    
    

    
    var body: some View {
        VStack {
            TextField("Income Name", text: $name)
                .autocapitalization(.none)
                .autocorrectionDisabled()
            
            TextField("Income Amount", text: $amount)
                .autocapitalization(.none)
                .autocorrectionDisabled()
            
        
            
            Button("Add Income") {
                DataController().addIncome(
                    name: name,
                   amount: Double(amount) ?? 0.0,
                    context: managedObjContext)
                dismiss()
            }
            .padding()
        }
    }
}

