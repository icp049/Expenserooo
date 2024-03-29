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
    
    
    func addIncome(name: String, amount: Double, context: NSManagedObjectContext ){
        let income = Income(context: context)
        income.id = UUID()
        income.date = Date()
        income.name = name
        income.amount = amount
        
        save(context: context)
        
        
    }
    
    
    func addSavings(savingsname: String, savingsamount: Double, context:NSManagedObjectContext){
        let savings = Savings(context: context)
        savings.savingsid = UUID()
        savings.savingsdate = Date()
        savings.savingsname = savingsname
        savings.savingsamount = savingsamount
        
        save(context: context)
    }
    
 
    
    
    
    func addBudget(name: String, sourcecategory: String, sourceamount: Double, expenses: [Expense], totalexpense: Double, extramoney: Double, context: NSManagedObjectContext) {
        let budget = Budget(context: context)
        budget.id = UUID()
        budget.date = Date()
        budget.name = name
        budget.sourceamount = sourceamount
        budget.sourcecategory = sourcecategory
        budget.totalexpense = totalexpense
        budget.extramoney = extramoney
      
        
        for expense in expenses {
            budget.addToExpenses(expense)
        }
        
        save(context: context)
    }
    
    
    
    /* func editBudget(budget: Budget, name: String, income: Double, expenses: [Expense], context: NSManagedObjectContext) {
        budget.date = Date()
        budget.name = name
        budget.income = income
        
        // Assuming you want to update the expenses as well, remove existing and add new ones
        budget.removeFromExpenses(budget.expenses ?? NSSet())
        for expense in expenses {
            budget.addToExpenses(expense)
        }
        
        save(context: context)
    }
    
    */
    
    
    
    
    
    
}
