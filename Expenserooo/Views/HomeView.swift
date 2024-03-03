import SwiftUI

struct HomeView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @EnvironmentObject var dataController: DataController // Access DataController as an environment object
    
    @State private var showingAddView = false
    @State private var showAddIncomeView = false
    
    @State private var totalIncome: Double = UserDefaults.standard.double(forKey: "totalincome")
    @State private var totalSavings: Double = UserDefaults.standard.double(forKey: "totalsavings")
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Total Income: \(formatAmount(totalIncome))")
                Text("Total Savings: \(formatAmount(totalSavings))")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddView.toggle()
                    } label: {
                        Label("Add Budget", systemImage: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showAddIncomeView.toggle()
                    } label: {
                        Label("Add Income", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddView) {
                AddBudgetView(totalIncome: $totalIncome, totalSavings: $totalSavings)
            }
            .sheet(isPresented: $showAddIncomeView) {
                AddIncomeView(totalIncome: $totalIncome, totalSavings: $totalSavings)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

