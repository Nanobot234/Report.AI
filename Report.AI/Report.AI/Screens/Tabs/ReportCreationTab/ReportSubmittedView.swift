//
//  ReportSubmittedView.swift
//  Report.AI
//
//  Created by Nana Bonsu on 11/12/24.
//

import SwiftUI

//Report Suvmitted Screen
struct ReportSubmittedView: View {
    @EnvironmentObject var reportList: Reports
    
    var completedReport: Report //the report
    var body: some View {
        
        
        
        VStack {
            
            //headerSection
            
            Spacer()
    
            Text("Report submitted!\nView the report in Reports Tab")
                .font(.title)
                .multilineTextAlignment(.center)
            
            Spacer()
            FuncttionNavLink(title: "Ok", destination: InitialProblemDescriptionViewControllerRepresentable().navigationBarBackButtonHidden(), funcToRun: nil)
                .padding()

        }
    }
}


#Preview {
    ReportSubmittedView(completedReport: Report(name: "Water break", images: [], description: "Ok"))
}
