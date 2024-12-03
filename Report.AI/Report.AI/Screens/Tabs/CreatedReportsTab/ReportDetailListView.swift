//
//  ReportDetailView.swift
//  Report.AI
//
//  Created by Yashraj Jadhav on 21/10/24.
//

import SwiftUI

struct ReportListDetailView: View {
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
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header Section with improved dark mode support
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(report.problemName)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text(report.dateReported?.formatted() ?? "No date available")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        // Enhanced Status Badge
                        Text(report.status.rawValue)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(statusColor.opacity(colorScheme == .dark ? 0.2 : 0.15))
                            .foregroundColor(statusColor)
                            .clipShape(Capsule())
                    }
                    
                    //The person your reporting too
                    Text("Reporting to: \(report.reportDestinationEntity)").bold()
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(15)
                .shadow(color: Color.primary.opacity(colorScheme == .dark ? 0.1 : 0.05), radius: 5)
                
                // Images Section with improved spacing
                if !report.images.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Photos")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(report.images, id: \.self) { imageData in
                                    if let image = UIImage(data: imageData) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 180, height: 180)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                            .shadow(color: Color.primary.opacity(0.1), radius: 4)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(15)
                }
                
                // Description Section with improved readability
                CardView(title: "Problem Description") {
                    Text(report.problemDescription)
                        .font(.body)
                        .foregroundColor(.primary.opacity(0.8))
                }
                
                // Location Section
                if let location = report.location {
                    CardView(title: "Location") {
                        HStack {
                            Image(systemName: "mappin.circle.fill")
                                .font(.title2)
                                .foregroundColor(.accentColor)
                            
                            Text(location)
                                .font(.body)
                                .foregroundColor(.primary.opacity(0.8))
                        }
                    }
                }
                
                // Solution Section
                if !report.userSolution.isEmpty {
                    CardView(title: "Solution") {
                        Text(report.userSolution)
                            .font(.body)
                            .foregroundColor(.primary.opacity(0.8))
                    }
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(UIColor.systemBackground))
    }
}

// MARK: - Helper Views
struct CardView<Content: View>: View {
    let title: String
    let content: Content
    @Environment(\.colorScheme) var colorScheme
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            content
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(15)
        .shadow(color: Color.primary.opacity(colorScheme == .dark ? 0.1 : 0.05), radius: 5)
    }
}

// Preview
struct ReportListDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ReportListDetailView(report: Report(
                name: "Water Leak",
                images: [],   
                description: "There is a significant water leak in the main pipeline.",
                location: "123 Main Street",
                userReported: User(name: "John Doe"), reportDestination: "Manager"
            ))
            
            
        }
    }
}
//struct CommentView: View {
//    let comment: Comment
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 4) {
//            Text(comment.user.name)
//                .font(.subheadline)
//                .fontWeight(.bold)
//            Text(comment.text)
//                .font(.body)
//            Text(comment.datePosted.formatted())
//                .font(.caption)
//                .foregroundColor(.secondary)
//        }
//        .padding()
//        .background(Color(.systemGray6))
//        .cornerRadius(8)
//    }
//}
