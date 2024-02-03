import SwiftUI
import CoreData
import LocalAuthentication

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @State private var showingAddView = false
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var income: FetchedResults<Income>
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                List {
                    ForEach(income) { income in
                        NavigationLink(destination: IncomeView(income: income)) {
                            HStack {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(income.name!)
                                        .bold()
                                        
                                        .font(.system(size: 15))
                                    
                                    
                                   
                                    Text("\(income.amount)")
                                                                           .bold()
                                                                           .font(.system(size: 15))
                                 
                                    
                                           
                                        
                    
                                  
                                    
                                }
                            }
                            
                        }
                    }
                    .onDelete(perform: deleteIncome)
                }
                .listStyle(.plain)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddView.toggle()
                    } label: {
                        Label("Add Account", systemImage: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Image("padlock")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                        
                        Text("Accounts")
                            .foregroundColor(.blue)
                            .font(.system(size: 22))
                    }
                }
            }
            .sheet(isPresented: $showingAddView) {
                AddIncomeView()
            }
        }
        .navigationViewStyle(.stack)
    }
    
    // Deletes account at the current offset
    private func deleteIncome(offsets: IndexSet) {
        withAnimation {
            offsets.map { income[$0] }
                .forEach(managedObjContext.delete)
            
            // Saves to our database
            DataController().save(context: managedObjContext)
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
