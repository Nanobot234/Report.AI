//
//  ComplaintModel.swift
//  Report.AI
//
//  Created by Nana Bonsu on 8/21/24.
//

import Foundation
import UIKit


//Struct describing what a complaint really means...

struct ReportModel {

    var name: String = ""
    /// List of image data for each image that the user chooes to upload
    var images: [Data]
    var description: String
    var location: String
    /// The user thats making the report
    var userReported: User
}



struct User {
    var name: String
    var phoneNumber: String?
    var emailAddress: String?
    //another attribute here, but not sure atm///
}
