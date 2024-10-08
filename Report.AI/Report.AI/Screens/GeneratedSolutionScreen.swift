//
//  GeneratedSolutionScreen.swift
//  Report.AI
//
//  Created by Nana Bonsu on 9/28/24.
//

import SwiftUI
import Foundation

struct GeneratedSolutionView: View {
    
    
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
                confirmationButton(title: "Yes") {
                    //add the solution to the report here, and then navigae to the last screen.
                }
                .padding(.bottom,10)
                
                confirmationButton(title: "No") {
                    
                }
            }
            .padding(.bottom,30)
        }
            .onAppear {
                
               
            }
        
        
        
    }
    
    
       
}

#Preview {
    GeneratedSolutionView(solutionText: "Good", problemName: "Nah", currentReport: Report())
}
