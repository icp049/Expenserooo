

import SwiftUI

struct AddIncomeView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    

    @State private var name = ""
    @State private var amount = ""
  
    
    var body: some View {
            Form {
                Section() {
                    TextField("Source", text: $name)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                    
                    TextField("Amount", text: $amount)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                    
         
                    
                    HStack {
                        Spacer()
                        
                        
                        RUButton(title: "Add Account", background:.black){
                            DataController().addIncome(
                                name: name,
                                amount: Double(amount) ?? 0.0,
                                context: managedObjContext)
                            dismiss()
                        }
                        .padding()
                        
                        
                        
                        
                   
                        Spacer()
                    }
                }
        }
    }
}

struct AddIncome_Previews: PreviewProvider {
    static var previews: some View {
        AddIncomeView()
    }
}
