//
//  GeneratedSolutionScreen.swift
//  Report.AI
//
//  Created by Nana Bonsu on 9/28/24.
//

import SwiftUI
import Foundation

struct GeneratedSolutionView: View {
    
    @EnvironmentObject var reportList: Reports
    @State var solutionText: String
    
    var problemName: String
    var currentReport: Report //the report that is currently being made.
    
    var body: some View {
        VStack {
            
            Spacer()
            Text("Possible solution to  \(problemName)")
            
            
            //further down after the edited text  box here
            
            TextEditor(text: $solutionText)
                .frame(height: 200)
                .border(Color.gray, width: 1)
                .padding(5)
            
            
            Text("Would you like to include this in your report?")
                .padding(.top,20)
            
            Spacer()
            VStack {
                
                
                NavLink(title: "Yes", destination: ReportSubmittedView()) {
                  //  self.addSolution() //chnagngin it here
                }
                
                
                
                
            }
            .padding(.bottom,30)
        }
        .onDisappear {
             //here will add report
            reportList.addReport(currentReport) //save the report to the global lsit
            }
    
    }
    
    mutating func addSolution() {
        self.currentReport.userSolution = solutionText
    }
      
}

#Preview {
    GeneratedSolutionView(solutionText: "Good", problemName: "Nah", currentReport: Report())
}
