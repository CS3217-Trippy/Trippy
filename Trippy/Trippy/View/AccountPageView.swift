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
    var user: User

    var userInfoSection: some View {
        Section {
            CircleImageView(url: session.currentLoggedInUser?.imageURL)
            Text("\(user.username)")
                .bold()
                .font(.title)
            Text(accountPageViewModel.email)
                .font(.headline)
        }
    }

    var changeProfilePictureSection: some View {
        Section {
            Text("CHANGE PROFILE PICTURE")
            if let selectedImage = accountPageViewModel.selectedImage {
                Image(uiImage: selectedImage)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
            }
            imagePickerButtons
            .buttonStyle(BorderlessButtonStyle())
        }
    }

    var changeUsernameSection: some View {
        Section {
            Text("CHANGE USERNAME")
            TextField("Enter new username", text: $accountPageViewModel.username)
                .frame(width: 400, height: nil, alignment: .center)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }

    var imagePickerButtons: some View {
        HStack {
            Button(action: {
                self.willLaunchCamera()
            }) {
                Text("CAMERA")
                    .frame(width: 150, height: nil, alignment: .center)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray)
                    )
            }

            Button(action: {
                self.imageSource = .photoLibrary
            }) {
                Text("PHOTO LIBRARY")
                    .frame(width: 150, height: nil, alignment: .center)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray)
                    )
            }
        }
    }

    var updateDeleteAccountButtons: some View {
        Section {
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

    private func willLaunchCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showCameraError = true
            return
        }
        imageSource = .camera
    }

    var body: some View {
        VStack(spacing: 10) {
            userInfoSection
            Spacer().frame(height: 25)
            LevelProgressionView(viewModel: LevelProgressionViewModel(session: session))
            Spacer().frame(height: 25)
            changeUsernameSection
            changeProfilePictureSection
                .fullScreenCover(item: $imageSource) { item in
                    ImagePicker(sourceType: item, selectedImage: $accountPageViewModel.selectedImage)
                }
                .alert(isPresented: $showCameraError, content: {
                    Alert(title: Text("No camera detected"))
                })
            Spacer().frame(height: 25)
            updateDeleteAccountButtons
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
