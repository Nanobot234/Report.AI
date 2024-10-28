//
//  CustomUIElements.swift
//  Report.AI
//
//  Created by Nana Bonsu on 9/30/24.
//

import Foundation
import SwiftUI



struct FuncttionNavLink<Destination: View>: View {
    let title: String
    let destination: Destination
    let funcToRun: (() -> Void)?

    var body: some View {
        NavigationLink(destination: destination) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.accentColor, Color.accentColor.opacity(0.8)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .shadow(color: Color.accentColor.opacity(0.3), radius: 5, x: 0, y: 3)
        } .simultaneousGesture(TapGesture().onEnded {
            if  let funcToRun = funcToRun {
                funcToRun()
            }
        })
        .padding(.top)

    }
}
