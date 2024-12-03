//
//  ActivityIndicator.swift
//  Report.AI
//
//  Created by Yashraj Jadhav on 17/10/24.
//

import SwiftUI

struct ActivityIndicator: View {
   // @State private var isLoading = false
    @State  var text: String
    
    var body: some View {
         
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(2)
                        
                    
                    Text(text)
                        .foregroundColor(.white)
                        .padding(.top, 20)
                }
                .frame(width: 200, height: 200)
                .background(Color.black.opacity(0.7))
                .cornerRadius(25)
            
        
        .onAppear {
          //  startNetworkCall()
        //    isLoading = True
            
        }
    }
    
  
}

#Preview {
    ActivityIndicator(text: "Updating Description")
}
