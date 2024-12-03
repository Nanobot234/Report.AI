//
//  ReportListView.swift
//  Report.AI
//
//  Created by Yashraj Jadhav on 21/10/24.
//

import SwiftUI

struct ReportListView: View {
    @EnvironmentObject var reports: Reports
    @State private var selectedReport: Report?
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        List {
            ForEach(reports.reportList) { report in
                NavigationLink(destination: ReportListDetailView(report: report)) {
                    ReportRowView(report: report)
                }
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(colorScheme == .dark ? Color(.systemGray6) : .white)
                        .padding(.vertical, 4)
                )
            }
        }
        .listStyle(PlainListStyle())
        .navigationBarTitle("Reports", displayMode: .large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: { }) {
                        Label("All Reports", systemImage: "list.bullet")
                    }
                    Button(action: { }) {
                        Label("Active Only", systemImage: "clock")
                    }
                    Button(action: { }) {
                        Label("Resolved", systemImage: "checkmark.circle")
                    }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .foregroundStyle(.primary)
                }
            }
        }
        .sheet(item: $selectedReport) { report in
            NavigationView {
                ReportListDetailView(report: report)
            }
        }
    }
}

struct ReportRowView: View {
    let report: Report
    @Environment(\.colorScheme) var colorScheme
    
    private var statusColor: Color {
        switch report.status {
        case .reported: return .yellow
        case .inProgress: return .blue
        case .resolved: return .green
        case .closed: return .gray
        }
    }
    
    private var categoryColor: Color {
        switch report.category {
        case .infrastructure: return .blue
        case .environment: return .green
        case .safety: return .red
        case .other: return .purple
        }
    }
    
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "Date not available" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title and Date
            HStack {
                Text(report.problemName)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text(formatDate(report.dateReported))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Category and Status
            HStack(spacing: 8) {
                // Category Badge
                HStack(spacing: 4) {
                    Circle()
                        .fill(categoryColor)
                        .frame(width: 8, height: 8)
                    
                    Text(report.category.rawValue.capitalized)
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    categoryColor
                        .opacity(colorScheme == .dark ? 0.15 : 0.1)
                )
                .cornerRadius(8)
                
                // Status Badge
                Text(report.status.rawValue.capitalized)
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        statusColor
                            .opacity(colorScheme == .dark ? 0.15 : 0.1)
                    )
                    .foregroundColor(statusColor)
                    .cornerRadius(8)
                
                Spacer()
                
                // Location indicator if available
                if report.location != nil {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.accentColor)
                        .font(.caption)
                }
            }
            
            // Preview of description if available
            if !report.problemDescription.isEmpty {
                Text(report.problemDescription)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .padding(.top, 4)
            }
        }
        .padding(.vertical, 8)
    }
}

// Preview
struct ReportListView_Previews: PreviewProvider {
    static var sampleReports: Reports = {
        let reports = Reports()
        let report1 = Report(
            name: "Water Leak",
            images: [],
            description: "Significant water leak in the main pipeline that needs immediate attention. The water is causing damage to the surrounding area.",
            location: "123 Main Street",
            userReported: User(name: "John Doe"), reportDestination: "management"
        )
        let report2 = Report(
            name: "Broken Streetlight",
            images: [],
            description: "Street light has been flickering for the past week and now completely stopped working.",
            location: "456 Oak Avenue",
            userReported: User(name: "Jane Smith"), reportDestination: "Bar"
        )
        reports.addReport(report1)
        reports.addReport(report2)
        return reports
    }()
    
    static var previews: some View {
        Group {
            NavigationView {
                ReportListView()
                    .environmentObject(sampleReports)
            }
            .preferredColorScheme(.light)
            
            NavigationView {
                ReportListView()
                    .environmentObject(sampleReports)
            }
            .preferredColorScheme(.dark)
        }
    }
}
