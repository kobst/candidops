//
//  CandidOpsApp.swift
//  CandidOps
//
//  Created by Edward Han on 7/20/24.
//

import SwiftUI

@main
struct CandidOpsApp: App {
    @State private var isAuthenticated = false

    var body: some Scene {
        WindowGroup {
            if isAuthenticated {
                ContentView()
            } else {
                LoginView(isAuthenticated: $isAuthenticated)
            }
        }
    }
}
