
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
                .background(Color(hex:"#430C0F"))
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
                    PostsView()
                case "Messages":
                    MessagesView()
                    
                case "Schedule":
                    Spacer()
                    ScheduleView()
                    Spacer()
                    Spacer()
                case "Map":
                    Spacer()
                    MapView()
                    Spacer()
                    Spacer()
                    SearchBar()
                    Spacer()
                default:
                    PostsView()
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
        center: CLLocationCoordinate2D(latitude: 51.745499, longitude: 19.454807),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )

    var body: some View {
        Map(coordinateRegion: $region)
            .frame(width: 385, height: 400)
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
        HStack(spacing: 0){
            Spacer()
            Image(systemName: "magnifyingglass")
                .foregroundColor(.white)
                .padding(.leading, 30)
               
            HStack {
              
                TextField("Search...", text: $searchText)
                    .foregroundColor(Color(.white)) // Text color
                    .placeholderColor(UIColor.lightGray) // Placeholder text color
                    
                    .padding(10) // Text field padding
                    .background(Color(hex: "#544343")) // Text field background color
                    .cornerRadius(15) // Text field corner radius
                
                
                if !searchText.isEmpty {
                    Button(action: {
                        self.searchText = ""
                    }) {
                        
                    }
                }
            }
            
            .background(Color.clear) // Search bar background color
            .cornerRadius(10) // Search bar corner radius
            .padding(.horizontal)
            .offset(y: -keyboardResponder.keyboardHeight)
            .animation(.easeOut, value: keyboardResponder.keyboardHeight)
            .onDisappear {
                // To hide the keyboard when this view disappears
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            Spacer()
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


struct PlaceholderColorModifier: ViewModifier {
    var color: UIColor
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = color
            }
    }
}

extension View {
    func placeholderColor(_ color: UIColor) -> some View {
        self.modifier(PlaceholderColorModifier(color: color))
    }
}
struct Post {
    let image: String
    let text: String
    let date: String
}

struct PostCard: View {
    var post: Post

    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(Color.white)
            .frame(height: 200)
            .padding()
            .overlay(
                VStack {
                    HStack {
                        Spacer()
                        Text(post.date)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.trailing, 10)
                            .padding(.top, 30)
                            .padding(.trailing, 30)
                    }
                    .frame(maxWidth: .infinity, alignment: .topTrailing)

                    Spacer()

                    VStack(alignment: .center){
                        HStack {
                            Image(post.image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                                .padding(.horizontal)
                                .padding(.leading, 30)

                                .cornerRadius(10)
                            Spacer()
                        }
                        
                        HStack {
                            Text(post.text)
                                .font(.body)
                                .foregroundColor(.black)
                                .padding(.leading, 30)
                                .padding(.trailing, 30)

                                .padding(.bottom, 10)
                            Spacer()
                        }
                    }
                    .padding(.bottom, 30)
                }
            )
    }
}

struct PostsView: View {
    // Sample data
    let posts: [Post] = [
        Post(image: "piwo", text: "Zapraszamy na flaneczki pod 3DS!!! dzis o 20:00", date: "2024-06-04"),
        Post(image: "party", text: "Juz jutro odbedzie sie wielka integracja osiedla...", date: "2024-06-02"),
        Post(image: "weed", text: "Zapraszamy do naszego kola naukowego pod nazwa...", date: "2024-06-03"),
        Post(image: "comp", text: "OpenAI oglosili nowa wersje swojej...", date: "2024-06-04")
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(posts.indices, id: \.self) { index in
                    PostCard(post: posts[index])
                }
            }
            .padding()
        }
    }
}

struct MessagesCard: View {
    var firstname: String
    var lastname: String
    var message: String
    var time: String
    var imageName: String

    
    var body: some View {
        HStack(spacing: 7) {
            VStack {
                Spacer()
                ZStack {
                                   Circle()
                                       .frame(width: 100, height: 100)
                                       .foregroundColor(.white) // Set background color of circle
                                   Image(imageName) // Use different image for each circle
                                       .resizable()
                                       .aspectRatio(contentMode: .fill)
                                       .frame(width: 96, height: 96)
                                       .clipShape(Circle())
                                       .overlay(
                                           Circle()
                                               .stroke(Color.white, lineWidth: 4) //
                                       )
                               }
            }
            VStack(alignment: .leading) {
                Text("\(firstname) \(lastname)")
                    .padding(.horizontal, 3)
                
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .frame(height: 50)
                    .overlay(
                        HStack {
                            Text(message)
                                .padding(.leading, 10)
                                .foregroundColor(.black)
                            Spacer()
                            Text(time)
                                .foregroundColor(.black)
                                .padding(.trailing, 10)
                                .padding(.leading, 3)

                        }
                    )
            }
        }
    }
}


struct MessagesView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                MessagesCard(firstname: "Vladyslav", lastname: "Doronchenkov", message: "Zrobiles Dante???", time: "20:38", imageName: "mirek")
                MessagesCard(firstname: "Antoni", lastname: "Jankowski", message: "Ale duzo mam na glowie...", time: "15:24", imageName: "aj")
                MessagesCard(firstname: "Praskouya", lastname: "Horbach", message: "Slayyyy", time: "10:23", imageName: "praska")
                MessagesCard(firstname: "Aliaksandra", lastname:"Sutorma", message: "Idziemy na fajke???", time: "00:12", imageName: "sasha")
                        }
            .padding()
        }
    }
}


struct Reminder: Identifiable {
    var id = UUID()
    var title: String
    var time: String
}

struct ScheduleView: View {
    @State private var selectedDate = Date()
    
    // Sample reminders for demonstration
    let reminders: [Date: [Reminder]] = [
        // Reminders for May 31, 2024
        Calendar.current.date(from: DateComponents(year: 2024, month: 5, day: 31))!: [
            Reminder(title: "Dante!!!", time: "10:00 AM"),
            Reminder(title: "AOI KOL2", time: "12:00 PM"),
            Reminder(title: "Flaneczki", time: "5:00 PM")
        ],
        // Reminders for June 1, 2024
        Calendar.current.date(from: DateComponents(year: 2024, month: 6, day: 1))!: [
            Reminder(title: "ESSAY DUE!", time: "2:00 PM")
        ],
        // Reminders for June 2, 2024
        Calendar.current.date(from: DateComponents(year: 2024, month: 6, day: 2))!: [
            Reminder(title: "Randka", time: "7:00 PM")
        ]
    ]

    var body: some View {
        VStack {
            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .frame(height: 300) // Set a height for the DatePicker
                .padding() // Add padding to create space between date picker and list
            
            VStack {
                if let dateReminders = reminders[Calendar.current.startOfDay(for: selectedDate)] {
                    List(dateReminders) { reminder in
                        VStack(alignment: .leading) {
                            Text(reminder.title)
                                .font(.headline)
                            Text(reminder.time)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .listRowBackground(Color(hex:"#430C0F")) // Change background color of each row
                    }
                    .listStyle(PlainListStyle())
                } else {
                    Text("No reminders for selected date")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .background(Color(hex:"#430C0F")) // Change background color of the container
            .cornerRadius(15) // Add corner radius for visual appeal
            .padding() // Add padding to container for spacing
        }
    }
}
