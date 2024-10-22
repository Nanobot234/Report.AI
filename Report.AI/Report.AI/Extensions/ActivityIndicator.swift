//
//  ActivityIndicator.swift
//  Report.AI
//
//  Created by Yashraj Jadhav on 17/10/24.
//

import SwiftUI

struct ActivityIndicator: View {
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.6)
                .ignoresSafeArea()
            VStack {
                Text("Example Screen")
                    .bold()
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
            }
            .padding(.bottom,190)
            
            if isLoading {
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(2)
                    
                    Text("Loading...")
                        .foregroundColor(.white)
                        .padding(.top, 10)
                }
                .frame(width: 100, height: 100)
                .background(Color.black.opacity(0.7))
                .cornerRadius(25)
            }
        }
        .onAppear { startNetworkCall() }
    }
    
    func startNetworkCall() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isLoading = false
        }
    }
}

#Preview {
    ActivityIndicator()
}
