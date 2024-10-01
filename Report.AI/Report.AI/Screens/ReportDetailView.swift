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
    @State private var selectedImage: UIImage? = nil
       @State private var address = ""
       @State private var descriptionText = ""
       @State private var isPhotoLibraryOpen = false
       @State private var isCameraOpen = false
      @State private var showAlert = false
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
                               .onTapGesture {
                                   selectedImage = image
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
                   .padding(.leading,80)
                 
                   Spacer()
                   
                   Text("\(images.count)/3")
                      
                
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
           .alert(isPresented: $showAlert) {
               Alert(
                title: Text("Delete Image"),
                message: Text("Are you sure you want to delete this image?"),
                primaryButton: .destructive(Text("Delete")) {
                    if let imageToDelete = selectedImage, let index = images.firstIndex(of: imageToDelete) {
                        images.remove(at: index) // Delete the image
                    }
                },
                secondaryButton: .cancel()
               )
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
    
    /// add empty `UIImage` objects to the array if the user has not chosen to add more images
    func adjustImageArray() {
        if(images.count == 1) {
            images[1] = UIImage()
            images[2] = UIImage()
        }
        if(images.count == 2){
            images[2] = UIImage()
        }
        
    }
    
    
    // TODO: complete function when creating a report
    func createReport() {
        
        let user = User(name: "Nana Bonsu",emailAddress: "Nbonsu2000@gmail.com")
        
        //let report =
    }
}

#Preview {
    InitalScreenView(initialImage: UIImage(), problemDescription: "Problem Here")
}
