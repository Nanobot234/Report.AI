//
//  Enums.swift
//  Report.AI
//
//  Created by Nana Bonsu on 10/30/24.
//

import Foundation

enum ReportStatus: String, Codable {
    case reported, inProgress, resolved, closed
}

enum ReportCategory: String, Codable {
    case infrastructure, environment, safety, other
    //government,school,
}
