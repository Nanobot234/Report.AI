//
//  GeneratedSolutionScreen.swift
//  Report.AI
//
//  Created by Nana Bonsu on 9/28/24.
//

import SwiftUI
import Foundation

struct GeneratedSolutionScreen: View {
    
    
    @State private var solutionText: String = ""
    
    var body: some View {
        VStack {
            
            Spacer()
            Text("Possible solution to  \(solutionText)")
            
            
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
                    
                }
                .padding(.bottom,10)
                
                confirmationButton(title: "No") {
                    
                }
            }
            .padding(.bottom,30)
        }
            .onAppear {
                solutionText = UserDefaults.standard.string(forKey: "problemDescription") ?? ""
            }
        
        
        
    }
    
    
       
}

#Preview {
    GeneratedSolutionScreen()
}
