
//
//  ComplaintModel.swift
//  Report.AI
//
//  Created by Nana Bonsu on 8/21/24.
//

import Foundation
import UIKit


//Struct describing what a complaint really means...


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
    
    
}


class Report: Identifiable, Codable {
    var id: UUID = UUID()
    var dateReported: Date?
//    var dateResolved: Date?
    
    var problemName: String = ""
    /// List of image data for each image that the user chooses to upload
    var images: [Data] = []
    var problemDescription: String = ""
    var location: String? = nil
    /// The user that's making the report
    var userSolution: String = ""
    var userReported: User = User()
    var status: ReportStatus
    var category: ReportCategory
    
    init() {
        // Default initializer
        self.status = .reported
        self.category = .other
    }
    
    init(category: ReportCategory) {
        self.status = .reported
        self.category = category
    }
    
    init(name: String, images: [Data], description: String, location: String, userReported: User) {
        self.problemName = name
        self.images = images
        self.problemDescription = description
        self.location = location
        self.userReported = userReported
        self.status = .reported  // Set default status
        self.category = .other   // Set default category
    }
    
    init(name: String, images: [Data], description: String) {
        self.problemName = name
        self.images = images
        self.problemDescription = description
        self.status = .reported  // Set default status
        self.category = .other   // Set default category
    }

}

struct User: Codable {
    var name: String = ""
    var phoneNumber: String?
    var emailAddress: String?
}
//  Maybe added 
//struct Comment: Identifiable, Codable {
//    var id: UUID = UUID()
//    var user: User
//    var text: String
//    var datePosted: Date
//}

enum ReportStatus: String, Codable {
    case reported, inProgress, resolved, closed
}

enum ReportCategory: String, Codable {
    case infrastructure, environment, safety, other
}
