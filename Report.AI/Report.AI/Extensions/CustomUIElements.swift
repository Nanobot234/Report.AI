//
//  CustomUIElements.swift
//  Report.AI
//
//  Created by Nana Bonsu on 9/30/24.
//

import Foundation
import SwiftUI



struct NavLink<Destination: View>: View {
    let title: String
    let destination: Destination
    let funcToRun: () -> Void

    var body: some View {
        NavigationLink(destination: destination) {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity, maxHeight: 50)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(20)
                .padding(.horizontal, 40)
        } .simultaneousGesture(TapGesture().onEnded {
                funcToRun()
        })

    }
}
