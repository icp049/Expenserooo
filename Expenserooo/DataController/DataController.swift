//
//  DataController.swift
//  Expenserooo
//
//  Created by Ian Pedeglorio on 2024-02-02.
//



import Foundation
import CoreData

class DataController: ObservableObject{
    let container  = NSPersistentContainer(name: "BudgetModel")

    init(){
        container.loadPersistentStores {desc, error in
        if let error = error {
            print("Failed to load the data \(error.localizedDescription)")
        }
        }
    }


   func save(context: NSManagedObjectContext){
    do {
        try context.save()
        print("Data saved")
    } catch {
        print("We can NOT save data...")
    }

   }
    
    
    func addBudget(name: String, income: Double, expenses: [Expense], context: NSManagedObjectContext) {
        let budget = Budget(context: context)
        budget.id = UUID()
        budget.date = Date()
        budget.name = name
        budget.income = income

        for expense in expenses {
            budget.addToExpenses(expense)
        }

        save(context: context)
    }
   /*/ func editBudget(income: Income, name: String, amount: Double, context:NSManagedObjectContext){
    income.date = Date()
    income.name = name
    income.amount = amount
  

    save(context:context)
   }
    */

}
