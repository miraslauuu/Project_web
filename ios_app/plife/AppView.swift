
//
//  AppView.swift
//  plife
//
//  Created by Miraslau Alkhovik on 21/04/2024.
//

import SwiftUI
import MapKit
import Combine


import SwiftUI

struct AppView: View {
    @State private var selectedTab: String = "Main Content"

    var body: some View {
        VStack(spacing: 0) {
            HeaderView2()
                .edgesIgnoringSafeArea(.top)
                .background(Color(hex: "#5E171B")) // Assumes HeaderView2 is static

            MainView(selectedTab: $selectedTab)  // Pass the state to MainView to control content
                .background(Color(hex: "#5E171B"))

            NavBar(selectedTab: $selectedTab)  // Pass the state to NavBar
                .frame(height: 100)
                .background(Color(hex: "#5E171B"))
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct HeaderView2: View {
    var body: some View {
        VStack(spacing: 0) {
            Image("header")
                .resizable()
                .scaledToFit()
            
        }
        .edgesIgnoringSafeArea(.all)

    }
    

}

struct MainView: View {
    @Binding var selectedTab: String

    var body: some View {
        ZStack {
            Color(hex: "#5E171B").edgesIgnoringSafeArea(.all) // Make sure the background color fills the entire screen

            VStack {
                switch selectedTab {
                case "Posts":
                    Text("Showing Posts")
                case "Messages":
                    Text("Showing Messages")
                case "Schedule":
                    Text("Showing Schedule")
                case "Map":
                    MapView()
                    SearchBar()
                default:
                    Text("Welcome")
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


struct NavBar: View {
    @Binding var selectedTab: String

    var body: some View {
        TabView(selection: $selectedTab) {
            Text("")
                .tabItem {
                    Image(systemName: "square.and.pencil")
                }
                .tag("Posts")

            Text("")
                .tabItem {
                    Image(systemName: "message.fill")
                }
                .tag("Messages")

            Text("")
                .tabItem {
                    Image(systemName: "calendar")
                }
                .tag("Schedule")

            Text("")
                .tabItem {
                    Image(systemName: "map.fill")
                }
                .tag("Map")
        }
        .frame(maxHeight: 65)
        .edgesIgnoringSafeArea(.top)
        .accentColor(.white)
    }
}




struct MapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        Map(coordinateRegion: $region)
            .cornerRadius(15)
            .edgesIgnoringSafeArea(.all)

            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(1)]), startPoint: .top, endPoint: .bottom), lineWidth: 10)
                    .blur(radius: 3)
                    .mask(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(
                                LinearGradient(gradient: Gradient(colors: [.black.opacity(1), .clear]), startPoint: .top, endPoint: .bottom)
                            )
                    )
            )
    }
}

struct SearchBar: View {
    @State private var searchText = ""
    @ObservedObject private var keyboardResponder = KeyboardResponder()

    var body: some View {
         VStack {
             TextField("Search...", text: $searchText)
                 .textFieldStyle(RoundedBorderTextFieldStyle())
                 .padding()
                 .offset(y: -keyboardResponder.keyboardHeight)
                         .animation(.easeOut, value: keyboardResponder.keyboardHeight)
                         .onDisappear {
                             // To hide the keyboard when this view disappears
                             UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                         }
         }
         .background(Color(hex: "#5E171B"))
      
     }

}



class KeyboardResponder: ObservableObject {
    @Published var keyboardHeight: CGFloat = 0
    private var cancellables: Set<AnyCancellable> = []

    init() {
        let keyboardWillShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .map { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero }
            .map { $0.height }

        let keyboardWillHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }

        Publishers.Merge(keyboardWillShow, keyboardWillHide)
            .subscribe(on: RunLoop.main)
            .assign(to: \.keyboardHeight, on: self)
            .store(in: &cancellables)
    }
}
