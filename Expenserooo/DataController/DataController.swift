//
//  DataController.swift
//  Expenserooo
//
//  Created by Ian Pedeglorio on 2024-02-02.
//



import Foundation
import CoreData

class DataController: ObservableObject{
    let container  = NSPersistentContainer(name: "IncomeModel")

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

    func addIncome(name: String, amount: Double, context: NSManagedObjectContext){
    
    let income = Income(context:context)
    income.id = UUID()
    income.date = Date()
    income.name = name
    income.amount = amount
    
    save(context:context)

   }

    func editIncome(income: Income, name: String, amount: Double, context:NSManagedObjectContext){
    income.date = Date()
    income.name = name
    income.amount = amount
  

    save(context:context)
   }

}
