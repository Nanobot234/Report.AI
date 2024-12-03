
//
//  ComplaintModel.swift
//  Report.AI
//
//  Created by Nana Bonsu on 8/21/24.
//

import Foundation
import UIKit


//Struct describing what a complaint really means...



#warning("Ask GPT about how to refactor this class.")
class Report: Identifiable, Codable {
    var id: String = String(UUID().uuidString.prefix(6))
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
    var reportDestinationEntity: String = "" //the person or organization that the user wants to submit a report to
    
    init() {
        // Default initializer
        self.status = .reported
        self.category = .other
    }
    
    init(category: ReportCategory) {
        self.status = .reported
        self.category = category
    }
    
    init(name: String, images: [Data], description: String, location: String, userReported: User, reportDestination: String) {
        self.problemName = name
        self.images = images
        self.problemDescription = description
        self.location = location
        self.userReported = userReported
        self.status = .reported  // Set default status
        self.category = .other   // Set default category
        self.reportDestinationEntity = reportDestination
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


