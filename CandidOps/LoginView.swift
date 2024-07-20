//
//  LoginView.swift
//  CandidOps
//
//  Created by Edward Han on 7/20/24.
//

import SwiftUI
import LocalAuthentication


struct LoginView: View {
    @Binding var isAuthenticated: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var showingRegistration = false

    var body: some View {
        NavigationView {
            VStack {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    login()
                }) {
                    Text("Login")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    authenticateWithFaceID { success, message in
                        if success {
                            isAuthenticated = true
                        } else {
                            alertMessage = message ?? "Face ID authentication failed"
                            showingAlert = true
                        }
                    }
                }) {
                    HStack {
                        Image(systemName: "faceid")
                        Text("Login with Face ID")
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                NavigationLink(destination: RegistrationView(isAuthenticated: $isAuthenticated)) {
                    Text("Don't have an account? Sign up")
                        .padding()
                }
            }
            .padding()
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Login Failed"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    func login() {
        if email.isEmpty || password.isEmpty {
            alertMessage = "Please enter both email and password"
            showingAlert = true
        } else {
            authenticateUser(email: email, password: password) { success, message in
                if success {
                    isAuthenticated = true
                } else {
                    alertMessage = message
                    showingAlert = true
                }
            }
        }
    }

    func authenticateUser(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
        if email == "test@example.com" && password == "password" {
            completion(true, "")
        } else {
            completion(false, "Invalid email or password")
        }
    }

    func authenticateWithFaceID(completion: @escaping (Bool, String?) -> Void) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Log in with Face ID"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        completion(true, nil)
                    } else {
                        completion(false, authenticationError?.localizedDescription)
                    }
                }
            }
        } else {
            completion(false, error?.localizedDescription)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isAuthenticated: .constant(false))
    }
}
