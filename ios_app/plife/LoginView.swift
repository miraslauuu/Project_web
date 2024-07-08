//
//  LoginView.swift
//  plife
//
//  Created by Miraslau Alkhovik on 18/04/2024.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue:  Double(b) / 255, opacity: Double(a) / 255)
    }
}

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoginSheetPresented: Bool = false
    
    var body: some View {
        VStack {
            HeaderView()
            Spacer()
            Button(action:{
                isLoginSheetPresented.toggle()
            }
            ){
                
                Text("Login")
                    .padding()
                    .font(.system(size: 30))
                    .frame(minWidth: 219)
                    .frame(minHeight: 103)
                    .foregroundColor(.black)
                    .background(Color(hex: "#D9D9D9"))
                    .cornerRadius(50)
                    
            }
            .padding()
            
            .sheet(isPresented: $isLoginSheetPresented){
                LoginSheetView()
            }
            Spacer()
        }
        .background(Color(hex: "#5E171B"))
        .ignoresSafeArea(.all)
        .edgesIgnoringSafeArea(.all)

    }
}

struct HeaderView: View {
    var body: some View {
        VStack(spacing: 0) {
            Image("header")
                .resizable()
                .scaledToFit()
            
        }
        .edgesIgnoringSafeArea(.all)

    }
    

}

struct LoginSheetView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Spacer() // Push content to the center vertically

            TextField("Username", text: $username)
                .padding()
                .background(Color(hex: "#5E171B"))
                .cornerRadius(10)
                .padding(.horizontal, 40) // Adjust horizontal padding as needed
            Spacer().frame(height: 20) // You can adjust the height as needed

            SecureField("Password", text: $password)
                .padding()
                .background(Color(hex: "#5E171B"))
                .cornerRadius(10)
                .padding(.horizontal, 40) // Adjust horizontal padding as needed

            Button(action: login) {
                Text("Login")
                    .padding()
                    .frame(width: 200, height: 50) // Increase the button size
                    .foregroundColor(Color(hex: "#bab3b3"))
                    .background(Color(hex: "#280709"))
                    .cornerRadius(20) // Smoother corner radius
            }
            .padding(.top, 20)

            Spacer() // Push content to the center vertically
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Make the VStack cover the whole screen
        .background(Color(hex: "#430C0F").edgesIgnoringSafeArea(.all)) // Set background color to cover the entire screen
        .fullScreenCover(isPresented: $isLoggedIn) {
            AppView()
        }
    }

    private func login() {
        // Assume the login is always successful for this example
        print("Logging in with username: \(username) and password: \(password)")
        isLoggedIn = true
    }
}

#Preview {
    LoginView()
}

#Preview {
    LoginView()
}
