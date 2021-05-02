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

    init(acccountPageViewModel: AccountPageViewModel) {
        self.accountPageViewModel = acccountPageViewModel
    }

    var userInfoSection: some View {
        Section {
            if let image = session.userImage {
                Image(uiImage: image).locationImageModifier()
            } else {
                Image("Placeholder").locationImageModifier()
            }
            Text("\(accountPageViewModel.username)")
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

    var accountInteractions: some View {
        Section {
            Button("SIGN OUT") {
                _ = self.session.signOut()
            }
            Button("UPDATE ACCOUNT") {
                accountPageViewModel.updateUserData()
            }
            ButtonWithConfirmation(
                buttonName: "DELETE ACCOUNT",
                warning: "Are you sure you want to delete your account?", image: nil) {
                accountPageViewModel.deleteUser()
            }.foregroundColor(.red)
            Text(accountPageViewModel.errorMessage)
                .foregroundColor(.red)
        }
    }

    func toAchievementsPage(user: User) -> some View {
        let achievementListViewModel = AchievementListViewModel(
            achievementModel: accountPageViewModel.achievementModel,
            imageModel: accountPageViewModel.imageModel,
            user: user
        )
        let achievementListView = AchievementListView(viewModel: achievementListViewModel)
        return NavigationLink(destination: achievementListView) {
            Text("ACHIEVEMENTS")
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

            if let user = accountPageViewModel.user {
                toAchievementsPage(user: user)
                Spacer().frame(height: 25)
            }

            if accountPageViewModel.isOwner {
                changeUsernameSection
                changeProfilePictureSection
                    .fullScreenCover(item: $imageSource) { item in
                        ImagePicker(sourceType: item, selectedImage: $accountPageViewModel.selectedImage)
                    }
                    .alert(isPresented: $showCameraError, content: {
                        Alert(title: Text("No camera detected"))
                    })
                Spacer().frame(height: 25)
                accountInteractions
            }
        }.navigationTitle("Account")
            .padding()
        }
    }
