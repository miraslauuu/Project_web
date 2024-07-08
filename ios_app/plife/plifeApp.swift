//
//  plifeApp.swift
//  plife
//
//  Created by Miraslau Alkhovik on 18/04/2024.
//

import SwiftUI

@main
struct plifeApp: App {
    init() {
        
        UITabBar.appearance().backgroundColor = UIColor(Color(hex:"#430C0F"))
        UISearchBar.appearance().backgroundColor = UIColor(Color(hex: "#5E171B"))
    }
    
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
