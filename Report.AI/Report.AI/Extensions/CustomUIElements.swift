//
//  CustomUIElements.swift
//  Report.AI
//
//  Created by Nana Bonsu on 9/30/24.
//

import Foundation
import SwiftUI

struct confirmationButton: View {
    var title: String
    var actionToPerform: () -> Void //performs an action here

    var body: some View {
        Button {
            actionToPerform()
        } label: {
            Text(title)
                .font(.headline)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 50)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .cornerRadius(20)
                .padding(.horizontal,40)
                //.shadow(radius: 5)
            //more here!!
        }
        .buttonStyle(.plain)

    }
}
