//
//  LoginViewModel.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 14/3/21.
//

import SwiftUI
import Combine

final class LoginViewModel: ObservableObject, Identifiable {
    var email = ""
    var password = ""
}
