import SwiftUI

struct HomeView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @EnvironmentObject var dataController: DataController // Access DataController as an environment object
    
    @State private var totalIncome: Double = UserDefaults.standard.double(forKey: "totalincome")
    @State private var totalSavings: Double = UserDefaults.standard.double(forKey: "totalsavings")
    
    var body: some View {
        VStack {
            Text("Total Income: \(formatAmount(totalIncome))")
            Text("Total Savings: \(formatAmount(totalSavings))")
        }
        .onAppear {
            // Fetch or update totalIncome and totalSavings here
            totalIncome = UserDefaults.standard.double(forKey: "totalincome")
            totalSavings = UserDefaults.standard.double(forKey: "totalsavings")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

