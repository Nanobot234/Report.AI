//
//  ReportViewModel.swift
//  Report.AI
//
//  Created by Nana Bonsu on 11/6/24.
//

import Foundation



class Reports: ObservableObject {
    @Published private(set) var reportList: [Report]
    
    let saveKey = "reportsData"
    init() {
        
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode([Report].self, from: data) {
                reportList = decoded
                //print("Printing userdefaults:\(UserDefaults.standard.string(forKey: "users_name")!)")
                
                if let userName = UserDefaults.standard.string(forKey: "users_name") {
                       print("Printing userdefaults: \(userName)")
                   } else {
                       print("No user name found in UserDefaults")
                   }
                
                return
            }
        }
            reportList = []
    }
    
    func saveData() {
        if let encoded = try? JSONEncoder().encode(reportList) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    ///  adds a new report to the array of `Report`
    /// - Parameter report: the object to add
    func addReport(_ report: Report) {
        reportList.append(report)
        
        saveData()
    }
    
    func getMostRecentReport() -> Report? {
        if let lastReport = reportList.last {
            return lastReport
        }
        return nil
    }
    
    
}
