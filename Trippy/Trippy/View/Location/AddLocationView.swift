//
//  AddLocationView.swift
//  Trippy
//
//  Created by QL on 17/3/21.
//

import SwiftUI
import CoreLocation
import MapKit
import Combine

struct AddLocationView: View {
    @State private var map = MKMapView()
    @State private var showLocationAlert = false
    @State private var locationName: String = ""
    @State private var locationDescription: String = ""
    @State private var showStorageError = false
    @State private var showPhotoLibrary = false
    @State private var showCamera = false
    @State private var selectedImage: UIImage?
    @State private var selectedLocation = CLLocationCoordinate2D()
    @State private var showCameraError = false
    @State private var selectedCategory: String = ""
    @State private var imageSource: UIImagePickerController.SourceType?
    let viewModel: AddLocationViewModel
    @Environment(\.presentationMode) var presentationMode

    var locationDetailsSection: some View {
        Section {
            Text("Please enter the name of the location. (Up to 50 characters)")
            TextField("Name of Location", text: $locationName)
            Text("Please enter a description of the location. (Up to 500 characters.)")
            TextEditor(text: $locationDescription)
        }
    }

    var locationMapSection: some View {
        Section {
            Text("Please select the location on the map.")
            AddLocationMapView(map: $map, showLocationAlert: $showLocationAlert, selectedLocation: $selectedLocation)
            .padding()
            .alert(isPresented: $showLocationAlert) {
                Alert(
                    title: Text("Unable to retrieve current location"),
                    message: Text("Please check that you have enabled the location permissions."))
            }
            .aspectRatio(contentMode: .fill)
        }
    }

    var photoSection: some View {
        Section {
            Text("Please submit a photo of the location if you have one! (optional)")
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
            }
            imagePickerButtons
            .buttonStyle(BorderlessButtonStyle())
        }
    }

    var imagePickerButtons: some View {
        HStack {
            Button(action: {
                self.willLaunchCamera()
            }) {
                Text("Launch Camera")
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray)
                )
            }

            Button(action: {
                self.imageSource = .photoLibrary
            }) {
                Text("Launch Photo Library")
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray)
                )
            }
        }
    }

    private func willLaunchCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showCameraError = true
            return
        }
        imageSource = .camera
    }

    var categorySelector: some View {
        Section {
            Picker("Category", selection: $selectedCategory) {
                ForEach(viewModel.categories, id: \.self) {
                    Text($0.capitalized)
                }
            }
        }
    }

    var submitSection: some View {
        Section {
            Button("Submit") {
                do {
                    try viewModel.saveForm(
                        name: locationName,
                        description: locationDescription,
                        category: selectedCategory,
                        coordinates: selectedLocation,
                        image: selectedImage
                    )
                } catch {
                    showStorageError = true
                }
                presentationMode.wrappedValue.dismiss()
            }
            .alert(isPresented: $showStorageError) {
                Alert(
                    title: Text("An error occurred while attempting to save the information.")
                )
            }
        }
    }

    var body: some View {
        Form {
            locationDetailsSection
            locationMapSection
            photoSection
            .fullScreenCover(item: $imageSource) { item in
                ImagePicker(sourceType: item, selectedImage: $selectedImage)
            }
            .alert(isPresented: $showCameraError, content: {
                Alert(title: Text("If only you had a camera"))
            })
            categorySelector
            submitSection
            .disabled(map.annotations.isEmpty
                        || !viewModel.isValidName(name: locationName)
                        || !viewModel.isValidDescription(description: locationDescription)
                        || !viewModel.isValidCategory(category: selectedCategory)
                     )
        }.navigationBarTitle("Submit new location")
    }
}

extension UIImagePickerController.SourceType: Identifiable {
    public var id: Int {
        hashValue
    }
}
