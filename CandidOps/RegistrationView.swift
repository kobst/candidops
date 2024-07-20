//
//  RegistrationView.swift
//  CandidOps
//
//  Created by Edward Han on 7/20/24.
//

import SwiftUI

struct RegistrationView: View {
    @Binding var isAuthenticated: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    @State private var showingImagePicker = false
    @State private var profileImage: UIImage? = nil
    
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Confirm Password", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            if let profileImage = profileImage {
                Image(uiImage: profileImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .padding()
            }
            
            Button(action: {
                showingImagePicker = true
            }) {
                Text(profileImage == nil ? "Upload Profile Photo" : "Change Profile Photo")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
            Button(action: {
                register()
            }) {
                Text("Register")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Registration Failed"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $profileImage)
        }
    }

    func register() {
        if email.isEmpty || password.isEmpty || confirmPassword.isEmpty || profileImage == nil {
            alertMessage = "Please fill in all fields and upload a profile photo"
            showingAlert = true
        } else if password != confirmPassword {
            alertMessage = "Passwords do not match"
            showingAlert = true
        } else {
            // Call your registration API
            registerUser(email: email, password: password, profileImage: profileImage!) { success, message in
                if success {
                    isAuthenticated = true
                } else {
                    alertMessage = message
                    showingAlert = true
                }
            }
        }
    }

    func registerUser(email: String, password: String, profileImage: UIImage, completion: @escaping (Bool, String) -> Void) {
        // Dummy registration logic
        // You need to implement your own logic to upload the image and register the user
        if email == "newuser@example.com" && password == "password" {
            completion(true, "")
        } else {
            completion(false, "Registration failed")
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(isAuthenticated: .constant(false))
    }
}
