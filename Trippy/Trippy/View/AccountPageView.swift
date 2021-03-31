//
//  AccountPageView.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 17/3/21.
//

import SwiftUI

struct AccountPageView: View {
    @EnvironmentObject var session: FBSessionStore
    @ObservedObject var accountPageViewModel: AccountPageViewModel
    @State private var imageSource: UIImagePickerController.SourceType?
    @State private var showCameraError = false
    @State private var selectedImage: UIImage?
    var user: User

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

    var body: some View {
        VStack(spacing: 10) {
            CircleImageView()
            Text("\(user.username)")
                .bold()
                .font(.title)
            Text(accountPageViewModel.email)
                .font(.headline)
            Spacer().frame(height: 25)
            LevelProgressionView(viewModel: LevelProgressionViewModel(session: session))
            Spacer().frame(height: 25)
            VStack {
                Text("CHANGE USERNAME")
                TextField("Enter new username", text: $accountPageViewModel.username)
                    .frame(width: 400, height: nil, alignment: .center)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            Spacer().frame(height: 25)
            photoSection
            .fullScreenCover(item: $imageSource) { item in
                ImagePicker(sourceType: item, selectedImage: $selectedImage)
            }
            .alert(isPresented: $showCameraError, content: {
                Alert(title: Text("If only you had a camera"))
            })
            VStack(spacing: 10) {
                Button("UPDATE ACCOUNT") {
                    accountPageViewModel.updateUserData()
                }
                Button("DELETE ACCOUNT") {
                    accountPageViewModel.deleteUser()
                }.foregroundColor(.red)
                Text(accountPageViewModel.errorMessage)
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
}

struct AccountPageView_Previews: PreviewProvider {
    static func setSession() -> FBSessionStore {
        let sessionStore = FBSessionStore()
        var userArray = [User]()
        userArray.append(User(id: "1", email: "1", username: "CAT", friendsId: [], levelSystemId: "1"))
        sessionStore.session = userArray
        return sessionStore
    }

    static func setUser() -> User {
        User(
            id: "1",
            email: "1",
            username: "CAT",
            friendsId: [],
            levelSystemId: "1"
        )
    }

    static var previews: some View {
        AccountPageView(
            accountPageViewModel: AccountPageViewModel(session: setSession()),
            user: setUser())
            .environmentObject(setSession())
    }
}
