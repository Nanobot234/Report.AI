import SwiftUI

struct GeneratedSolutionView: View {
    // MARK: - Properties
    @State private var solutionText: String
    @State private var isEditing: Bool = false
    @State private var isIncludingSolution: Bool = false
    private let problemName: String
    var currentReport: Report
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var reportList: Reports

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
            .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            .navigationBarTitle("Solution", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton(isEditing: $isEditing)
                }
            }
            .onAppear {
               
            }
            .onDisappear {
                // Save the report to the global list
            }
        }
    }
    
    // MARK: - Section Views
    private var headerSection: some View {
        VStack(spacing: 16) {
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
                .shadow(color: Color.black.opacity(0.08), radius: 15, x: 0, y: 5)
        )
    }
    
    private var solutionTextEditor: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Label("Suggested Solution", systemImage: "text.quote")
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                if isEditing {
                    EditingBadge()
                }
            }
            Group {
                if isEditing {
                    TextEditor(text: $solutionText)
                        .frame(minHeight: 200)
                        .padding(12)
                        .background(colorScheme == .dark ? Color(.secondarySystemBackground) : Color(.systemBackground))
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.blue.opacity(0.5), lineWidth: 2))
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
                .shadow(color: Color.black.opacity(0.08), radius: 15, x: 0, y: 5)
        )
    }
    
    private var confirmationSection: some View {
        VStack(spacing: 20) {
            Text("Include this solution in your report?")
                .font(.headline)
                .foregroundColor(.primary)
            HStack(spacing: 16) {
                
                FuncttionNavLink(title: "Yes, Include", destination: ReportSubmittedView(completedReport: currentReport).navigationBarBackButtonHidden(), funcToRun: addToLocalAndS3Storage)
//                ActionButton(title: "Yes, Include", icon: "checkmark.circle.fill", color: .green) {
//                    addSolution()
//                        addToLocalAndS3Storage()
//                        
//                }
                
                FuncttionNavLink(title: "No, Discard", destination: ReportSubmittedView(completedReport: currentReport).navigationBarBackButtonHidden(), funcToRun: addToLocalAndS3Storage)
                
                
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.08), radius: 15, x: 0, y: 5)
        )
    }
    
    // MARK: - Actions
    private func addSolution() {
        currentReport.userSolution = solutionText
    }
    
    private func addToLocalAndS3Storage() {
        
        if isIncludingSolution {
            addSolution()
        }
        
        Task {
            let currentUser = User(name: "Nana", phoneNumber: "6467012471", emailAddress: "")
            //            currentReport.userReported = currentUser
            let path = "public/\(currentReport.id)"
            await AWSServiceManager.shared.uploadReport(report: currentReport, path: path) { result in
                switch result {
                case .success(let val):
                    print("Success", val)
                    DispatchQueue.main.async {
                        reportList.addReport(currentReport) //add it to reportList, local storage
                    }
                case .failure(let err):
                    print("Error", err.localizedDescription)
                }
            }
        }
    }
    
//    private func encodeandUploadtoS3() {
//        Task {
//            let currentUser = User(name: "Nana", phoneNumber: "6467012471", emailAddress: "")
//            currentReport.userReported = currentUser
//            await AWSServiceManager.shared.uploadReport(report: currentReport, key: currentReport.id.uuidString) { result in
//                reportList.addReport(currentReport)
//                print("Report uploaded")
//            }
//        }
//    }

    private func discardAction() {
        presentationMode.wrappedValue.dismiss()
    }
}

// MARK: - Supporting Views
struct EditButton: View {
    @Binding var isEditing: Bool
    var body: some View {
        Button(action: { isEditing.toggle() }) {
            Text(isEditing ? "Done" : "Edit").fontWeight(.semibold).foregroundColor(.blue)
        }
    }
}

struct EditingBadge: View {
    var body: some View {
        Text("Editing").font(.caption).fontWeight(.medium).padding(10).background(
            Color.blue.opacity(0.15)).foregroundColor(.blue).clipShape(Capsule())
    }
}

struct ActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon).font(.system(size: 16, weight: .semibold))
                Text(title).fontWeight(.semibold)
            }
            .padding(.vertical, 16)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(15)
        }
    }
}

