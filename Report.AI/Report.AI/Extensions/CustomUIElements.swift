//
//  CustomUIElements.swift
//  Report.AI
//
//  Created by Nana Bonsu on 9/30/24.
//

import Foundation
import SwiftUI

struct confirmationButton: View {
    let title: String
    let style: ButtonStyle
    let action: () -> Void
    
    enum ButtonStyle {
        case primary, secondary
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(style == .primary ? Color.blue : Color.clear)
                .foregroundColor(style == .primary ? .white : .blue)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(style == .secondary ? Color.blue : Color.clear, lineWidth: 1)
                )
        }
        .cornerRadius(10)
        .buttonStyle(PlainButtonStyle())
    }
}
