//
//  GeneratedSolutionScreen.swift
//  Report.AI
//
//  Created by Nana Bonsu on 9/28/24.
//
import SwiftUI

struct GeneratedSolutionView: View {
    // MARK: - Properties
    @State private var solutionText: String
    @State private var isEditing: Bool = false
    private let problemName: String
    private let currentReport: Report
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - Init
    init(solutionText: String, problemName: String, currentReport: Report) {
        _solutionText = State(initialValue: solutionText)
        self.problemName = problemName
        self.currentReport = currentReport
    }

    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerSection
                solutionTextEditor
                confirmationSection
            }
            .padding(.horizontal)
            .padding(.vertical, 24)
        }
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        .navigationBarTitle("Solution", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton(isEditing: $isEditing)
            }
        }
    }
    
    // MARK: - Section Views
    private var headerSection: some View {
        VStack(spacing: 16) {
            // Icon Container
            Circle()
                .fill(Color.yellow.opacity(0.15))
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.yellow)
                )
                .shadow(color: .yellow.opacity(0.3), radius: 10, x: 0, y: 5)
            
            VStack(spacing: 8) {
                Text("Suggested solution for")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(problemName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
            }
        }
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(
                    color: Color.black.opacity(0.08),
                    radius: 15,
                    x: 0,
                    y: 5
                )
        )
    }
    
    private var solutionTextEditor: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Label {
                    Text("Suggested Solution")
                        .font(.headline)
                        .foregroundColor(.primary)
                } icon: {
                    Image(systemName: "text.quote")
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                if isEditing {
                    EditingBadge()
                }
            }
            
            // Content
            Group {
                if isEditing {
                    TextEditor(text: $solutionText)
                        .frame(minHeight: 200)
                        .padding(12)
                        .background(colorScheme == .dark ? Color(.secondarySystemBackground) : Color(.systemBackground))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.blue.opacity(0.5), lineWidth: 2)
                        )
                } else {
                    ScrollView {
                        Text(solutionText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(12)
                    }
                    .frame(minHeight: 200)
                    .background(colorScheme == .dark ? Color(.secondarySystemBackground) : Color(.systemBackground))
                    .cornerRadius(12)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(
                    color: Color.black.opacity(0.08),
                    radius: 15,
                    x: 0,
                    y: 5
                )
        )
    }
    
    private var confirmationSection: some View {
        VStack(spacing: 20) {
            Text("Include this solution in your report?")
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack(spacing: 16) {
                ActionButton(
                    title: "Yes, Include",
                    icon: "checkmark.circle.fill",
                    color: .green,
                    action: includeAction
                )
                
                ActionButton(
                    title: "No, Discard",
                    icon: "xmark.circle.fill",
                    color: .red,
                    action: discardAction
                )
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(
                    color: Color.black.opacity(0.08),
                    radius: 15,
                    x: 0,
                    y: 5
                )
        )
    }
    
    // MARK: - Actions
    private func includeAction() {
        presentationMode.wrappedValue.dismiss()
    }
    
    private func discardAction() {
        presentationMode.wrappedValue.dismiss()
    }
}

// MARK: - Supporting Views
struct EditButton: View {
    @Binding var isEditing: Bool
    
    var body: some View {
        Button(action: { isEditing.toggle() }) {
            Text(isEditing ? "Done" : "Edit")
                .fontWeight(.semibold)
                .foregroundColor(.blue)
        }
    }
}

struct EditingBadge: View {
    var body: some View {
        Text("Editing")
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color.blue.opacity(0.15))
            .foregroundColor(.blue)
            .clipShape(Capsule())
    }
}

struct ActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                Text(title)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    gradient: Gradient(
                        colors: [
                            color,
                            color.opacity(0.8)
                        ]
                    ),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .foregroundColor(.white)
            .cornerRadius(15)
            .shadow(
                color: color.opacity(0.3),
                radius: 8,
                x: 0,
                y: 4
            )
        }
    }
}

// MARK: - Preview
struct GeneratedSolutionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GeneratedSolutionView(
                solutionText: """
                1. Contact local waste management services to report the overflow.
                2. Request an immediate pickup or additional containers.
                3. Implement a recycling program to reduce waste volume.
                4. Educate community members on proper waste disposal and recycling practices.
                5. Consider increasing the frequency of scheduled pickups.
                """,
                problemName: "Overflowing Trash Container",
                currentReport: Report()
            )
        }
    }
}
