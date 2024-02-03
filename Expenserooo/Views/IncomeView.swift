
import SwiftUI

struct IncomeView: View {
    var income: Income
    
    var body: some View {
        VStack {
            Text("Income Details")
                .font(.title)
                .bold()
                .padding()
            
            Spacer()
            
            Text("Name: \(income.name ?? "")")
                .padding()
            
            Text("Amount: \(income.amount ?? 0.0)")
                         .padding()
            
            Spacer()
        }
        .navigationBarTitle(income.name ?? "Income", displayMode: .inline)
    }
}

struct IncomeView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleIncome = Income() // Assuming you have a default initializer for Income
        return IncomeView(income: sampleIncome)
    }
}
