//
//  InitalScreenView.swift
//  Report.AI
//
//  Created by Nana Bonsu on 9/25/24.
//

import SwiftUI

struct InitalScreenView: View {
  
    
    @State private var images: [UIImage] = []
       @State private var selectedDate = Date()
       @State private var address = ""
       @State private var descriptionText = ""
       @State private var isPhotoLibraryOpen = false
       @State private var isCameraOpen = false
      var initialImage: UIImage
    var problemDescription: String
       var body: some View {
           VStack {
               // Horizontal Scrollable List of Images
               if !problemDescription.isEmpty {
                   Text(problemDescription)
               }
               ScrollView(.horizontal, showsIndicators: false) {
                   HStack {
                       ForEach(images, id: \.self) { image in
                           Image(uiImage: image)
                               .resizable()
                               .scaledToFit()
                               .frame(width: 150, height: 200)
                               
                               .padding(.horizontal, 5)
                       }
                   }
                   .padding(.vertical, 10)
               }
               .frame(height: 200)
               .border(Color.gray, width: 1)
               
               // Button to Add Image
              
               HStack {
                   Button("Add an Image") {
                       isPhotoLibraryOpen = true
                   }
                   
                   Button("Take a Photo") {
                      isCameraOpen = true
                   }
                   
               }
               .sheet(isPresented: $isPhotoLibraryOpen) {
                   PhotoPicker(images: $images)
               }
               .sheet(isPresented: $isCameraOpen) {
                   CameraPicker(images: $images)
               }
               
               // Form for Date Picker, Address, and Description
               Form {
                   Section(header: Text("Select Date and Time")) {
                       DatePicker("", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                       //center aline here
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
               
               
               Button("Continue") {}
                   .padding(.top,20)
           }
           .navigationTitle("Problem")
           .padding()
           .onAppear {
               addInitialImage()
           }
       }
    
    func addInitialImage() {
        images.append(initialImage)
    }
}

#Preview {
    InitalScreenView(initialImage: UIImage(), problemDescription: "Problem Here")
}
