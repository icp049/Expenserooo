//
//  SharedData.swift
//  Expenserooo
//
//  Created by Ian Pedeglorio on 2024-03-03.
//

import Foundation
import SwiftUI

class SharedData: ObservableObject {
    @Published var totalIncome: Double = UserDefaults.standard.double(forKey: "totalincome")
    @Published var totalSavings: Double = UserDefaults.standard.double(forKey: "totalsavings")
}
