
//
//  AppView.swift
//  plife
//
//  Created by Miraslau Alkhovik on 21/04/2024.
//

import SwiftUI
import MapKit


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
                   
                Spacer()
            default:
                Text("Welcome")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "#5E171B"))
        .edgesIgnoringSafeArea(.all)
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
            .frame(width: 400, height: 400)
            .cornerRadius(15)
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
            .edgesIgnoringSafeArea(.all)
    }
}

