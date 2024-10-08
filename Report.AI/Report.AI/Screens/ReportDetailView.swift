//
//  InitalScreenView.swift
//  Report.AI
//
//  Created by Nana Bonsu on 9/25/24.
//

import SwiftUI

//
//  InitialScreenView.swift
//  Report.AI
//
//  Created by Nana Bonsu on 9/25/24.
//

import SwiftUI


struct ReportDetailView: View {

    
    @State private var images: [UIImage] = []
    @State private var selectedDate = Date()
    @State private var selectedImage: UIImage? = nil
    @State private var address = ""
    @State private var descriptionText = ""
    @State private var isPhotoLibraryOpen = false
    @State private var isCameraOpen = false
    @State private var showAlert = false

    @State private var solutionText = ""
    @State private var newReport = Report()

    var initialImage: UIImage
    var problemDescription: String
    var problemName: String
    
    var body: some View {

            VStack {
                // Horizontal Scrollable List of Images
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(images.indices, id: \.self) { index in
                            Image(uiImage: images[index])
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 200)
                                .onTapGesture {
                                    selectedImage = images[index]
                                    showAlert = true
                                }
                                .padding(.horizontal, 5)
                        }
                    }
                    .padding(.vertical, 10)
                }
                .frame(height: 200)
                .border(Color.gray, width: 1)

                
                // Button to Add Image
                HStack {
                    HStack {
                        Button("Add Photos") {
                            isPhotoLibraryOpen = true
                        }
                        .disabled(images.count == 3)
                        
                        Button("Take a Photo") {
                            isCameraOpen = true
                        }
                    }
                    .padding(.leading, 80)
                    
                    Spacer()
                    
                    Text("\(images.count)/3")
                }
                .sheet(isPresented: $isPhotoLibraryOpen) {
                    PhotoPicker(images: $images, description: $descriptionText, updateReport: createReport)
                }
                .sheet(isPresented: $isCameraOpen) {
                    CameraPicker(images: $images)
                }
                
                // Form for Date Picker, Address, and Description
                Form {
                    Section(header: Text("Select Date and Time")) {
                        DatePicker("", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                    }

                    
                    Section(header: Text("Address")) {
                        TextField("Enter Address", text: $address)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    .listRowBackground(Color.clear)
                    
                    Section(header: Text("Description")) {
                        TextEditor(text: $descriptionText)
                            .frame(height: 200)
                            .border(Color.gray, width: 1)
                            .padding(.top, 5)
                    }
                    .listRowBackground(Color.clear)
                }
                
                //change button to nav link

                
                NavigationLink(destination: GeneratedSolutionView(solutionText: solutionText, problemName: problemName, currentReport: newReport)) {
                     Text("Continue")
                }
                

            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Delete Image"),
                    message: Text("Are you sure you want to delete this image?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let imageToDelete = selectedImage, let index = images.firstIndex(of: imageToDelete) {
                            images.remove(at: index)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
            .navigationTitle("\(problemName) Report Details")

        .padding()
        .onAppear {
        
            addInitialImage()
            descriptionText = problemDescription
            Task {
                //make the solution description right away.
                solutionText = await GeminiManager.shared.generateSolutionFromProblem(problemDescription: problemDescription)
            }
            
            createReport()
            

        }
    }
    
    func addInitialImage() {
        if(images.isEmpty) {
            images.append(initialImage)
        }
    }
    
    func convertImagesToData() -> [Data] {
        
     var dataArray: [Data] = []
        for image in images {
            if let imageData = image.pngData() {
                dataArray.append(imageData)
            }
        }
        
        return dataArray
    }
 
    func createReport() {
        
        //TODO: make the report here
          //= User(name: "Nana Bonsu", emailAddress: "Nbonsu2000@gmail.com") //will need to have a user here 4 sure
        
        // Implement report creation logic
        let imgDataArray = convertImagesToData()
        
         newReport = Report(name: problemName, images: imgDataArray, description: problemDescription)
        
        print("Report Description now: \(newReport.problemDescription)")

    }
}


#Preview {

    ReportDetailView(initialImage: UIImage(), problemDescription: "Problem Here",problemName: "name")

}
